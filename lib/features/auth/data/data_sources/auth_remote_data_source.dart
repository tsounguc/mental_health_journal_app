import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> createUserAccount({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  });

  Future<void> deleteAccount({
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore firestoreClient,
    required FirebaseStorage storageClient,
  })  : _authClient = authClient,
        _firestoreClient = firestoreClient,
        _storageClient = storageClient;
  final FirebaseAuth _authClient;
  final FirebaseFirestore _firestoreClient;
  final FirebaseStorage _storageClient;
  @override
  Future<UserModel> createUserAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      final timestamp = Timestamp.now();

      await _setUserData(
        _authClient.currentUser,
        email,
        timestamp: timestamp,
      );

      final user = UserModel(
        uid: userCredential.user?.uid ?? '',
        name: userCredential.user?.displayName ?? '',
        email: userCredential.user?.email ?? '',
        dateCreated: DateTime.fromMicrosecondsSinceEpoch(
          timestamp.microsecondsSinceEpoch,
        ),
        profilePictureUrl: userCredential.user?.photoURL,
        isVerified: false,
      );

      return user;
    } on FirebaseAuthException catch (e) {
      throw CreateUserAccountException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } on CreateUserAccountException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw CreateUserAccountException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> deleteAccount({required String password}) async {
    try {
      await _authClient.currentUser?.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: _authClient.currentUser!.email ?? '',
          password: password,
        ),
      );

      await _users.doc(_authClient.currentUser!.uid).delete();

      final ref = _storageClient.ref().child('profile_pics/${_authClient.currentUser?.uid}');
      await ref.getDownloadURL().then((response) {
        ref.delete();
      }).catchError((error) async {});

      await _authClient.currentUser!.delete();
      await _authClient.currentUser!.reload();
    } on FirebaseException catch (e) {
      var errorMessage = e.message ?? 'An error occurred. Please try again';
      if (e.code == 'user-mismatch' || e.code == 'invalid-credential' || e.code == 'wrong-password') {
        errorMessage = 'Invalid credentials. Please try again';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts. Please try again later';
      } else {
        errorMessage = 'An error occurred. Please try again';
      }
      debugPrint(e.code);
      throw DeleteAccountException(
        message: errorMessage,
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw DeleteAccountException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ForgotPasswordException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ForgotPasswordException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;

      // get user data from firestore with user uid
      var userData = await _getUserData(user!.uid);
      var userModel = UserModel.empty();
      if (!userData.exists) {
        // if user doesn't have data in firestore
        // upload data to firestore
        final timestamp = Timestamp.now();
        await _setUserData(user, email, timestamp: timestamp);

        // get user data from firestore with user uid
        userData = await _getUserData(user.uid);
        userModel = UserModel.fromMap(userData.data()!);
      } else {
        userModel = UserModel.fromMap(userData.data()!);
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      var errorMessage = e.message ?? 'An error occurred. Please try again';
      if (e.code == 'user-mismatch' || e.code == 'invalid-credential' || e.code == 'wrong-password') {
        errorMessage = 'Invalid username or password. Please try again';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Too many attempts. Please try again later';
      }
      throw SignInException(
        message: errorMessage,
        statusCode: e.code,
      );
    } on SignInException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw SignInException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
      await _authClient.currentUser!.reload();
    } on FirebaseException catch (e) {
      throw SignOutException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw SignOutException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser({
    required UpdateUserAction action,
    required dynamic userData,
  }) async {
    try {
      switch (action) {
        case UpdateUserAction.name:
          await _authClient.currentUser?.updateDisplayName(
            userData as String,
          );
          await _updateUserData({'name': userData});
        case UpdateUserAction.email:
          await _authClient.currentUser?.verifyBeforeUpdateEmail(
            userData as String,
          );
          await _updateUserData({'email': userData});
        case UpdateUserAction.password:
          // this case is when user is already logged in
          // and is trying to change password in user settings
          final newData = jsonDecode(userData as String) as DataMap;
          if (_authClient.currentUser?.email == null) {
            throw const UpdateUserException(
              message: 'User does not exist',
              statusCode: 'Insufficient Permission',
            );
          }
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
        case UpdateUserAction.profilePictureUrl:
          // Save new picture in firebase storage
          final ref = _storageClient.ref().child('profile_pics/${_authClient.currentUser?.uid}');
          await ref.putFile(userData as File);

          // Save get url from firebase storage
          final url = await ref.getDownloadURL();

          // Update it in firebase auth
          await _authClient.currentUser?.updatePhotoURL(url);

          // Update document url in firestore
          await _updateUserData({'photoUrl': url});
      }
    } on FirebaseException catch (e) {
      throw UpdateUserException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw UpdateUserException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<void> _setUserData(
    User? user,
    String fallbackEmail, {
    Timestamp? timestamp,
  }) async {
    await _users.doc(user?.uid).set(
          UserModel(
            uid: user?.uid ?? '',
            name: user?.displayName ?? '',
            email: user?.email ?? fallbackEmail,
            dateCreated: timestamp?.toDate() ?? DateTime.now(),
            profilePictureUrl: user?.photoURL,
            isVerified: false,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _users
        .doc(
          _authClient.currentUser?.uid,
        )
        .update(data);
  }

  CollectionReference<DataMap> get _users => _firestoreClient.collection(
        'users',
      );

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _users.doc(uid).get();
  }
}
