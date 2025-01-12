import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/utils/firebase_constants.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {
  String _uid = 'Test uid';

  @override
  String get uid => _uid;

  set uid(String value) {
    if (_uid != value) _uid = value;
  }
}

class MockUserCredential extends Mock implements UserCredential {
  MockUserCredential([User? user]) : _user = user;
  User? _user;

  @override
  User? get user => _user;

  set user(User? value) {
    if (_user != value) _user = value;
  }
}

class MockAuthCredential extends Mock implements AuthCredential {}

void main() {
  late FirebaseAuth authClient;
  late FirebaseFirestore firestoreClient;
  late MockFirebaseStorage storageClient;
  late DocumentReference<DataMap> userDocRef;
  late MockUser mockUser;
  late UserCredential userCredential;

  late AuthRemoteDataSourceImpl remoteDataSource;

  final testUserModel = UserModel.empty();
  const testPassword = '12345678';

  final testFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user recod corresponding to this identifier.',
  );

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    firestoreClient = FakeFirebaseFirestore();
    storageClient = MockFirebaseStorage();

    userDocRef = firestoreClient.collection(FirebaseConstants.usersCollection).doc();

    await userDocRef.set(
      testUserModel.copyWith(uid: userDocRef.id).toMap(),
    );

    mockUser = MockUser()..uid = userDocRef.id;

    userCredential = MockUserCredential(mockUser);

    remoteDataSource = AuthRemoteDataSourceImpl(
      authClient: authClient,
      firestoreClient: firestoreClient,
      storageClient: storageClient,
    );

    when(() => authClient.currentUser).thenAnswer((_) => mockUser);
  });

  test(
    'given AuthRemoteDataSourceImpl '
    'when instantiated '
    'then instance should be a subclass of [AuthRemoteDataSource]',
    () {
      // Arrange
      // Act
      // Assert
      expect(remoteDataSource, isA<AuthRemoteDataSource>());
    },
  );

  group('createUserAccount - ', () {
    test(
      'given AuthRemoteDataSourceImpl, '
      'when [AuthRemoteDataSourceImpl.createUserAccount] is called '
      'then return [UserEntity]  ',
      () async {
        // Arrange
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(
              named: 'password',
            ),
          ),
        ).thenAnswer((_) async => userCredential);

        when(
          () => userCredential.user?.updateDisplayName(any()),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await remoteDataSource.createUserAccount(
          name: testUserModel.name,
          email: testUserModel.email,
          password: testPassword,
        );

        // Assert
        expect(result, isA<UserModel>());
        expect(result.uid, userCredential.user?.uid);

        await untilCalled(
          () => userCredential.user?.updateDisplayName(any()),
        );

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: testUserModel.email,
            password: testPassword,
          ),
        ).called(1);

        verify(
          () => userCredential.user?.updateDisplayName(
            testUserModel.name,
          ),
        ).called(1);
      },
    );

    test(
      'given AuthRemoteDataSourceImpl, '
      'when [AuthRemoteDataSource.createUserAccount] call is unsuccessful '
      'and [FirebaseAuthException] is thrown '
      'then throw [CreateWithEmailAndPasswordException] ',
      () async {
        // Arrange
        when(
          () => authClient.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(testFirebaseAuthException);

        // Act
        final methodCall = remoteDataSource.createUserAccount;

        // Assert
        expect(
          () async => methodCall(
            name: testUserModel.name,
            email: testUserModel.email,
            password: testPassword,
          ),
          throwsA(isA<CreateUserAccountException>()),
        );

        verify(
          () => authClient.createUserWithEmailAndPassword(
            email: testUserModel.email,
            password: testPassword,
          ),
        ).called(1);
      },
    );
  });

  group('deleteAccount - ', () {
    setUp(() {
      mockUser = MockUser()..uid = userDocRef.id;
      registerFallbackValue(MockAuthCredential());
    });
    test(
      'given AuthRemoteDataSourceImpl, '
      'when [AuthRemoteDataSourceImpl.deleteAccount] is called '
      'and no [Exception] is thrown '
      'then complete successfully ',
      () async {
        // Arrange
        when(
          () => mockUser.reauthenticateWithCredential(any()),
        ).thenAnswer((_) async => userCredential);

        when(
          () => mockUser.delete(),
        ).thenAnswer((_) async => Future.value());

        when(() => mockUser.reload()).thenAnswer((_) async => Future.value());

        // Act
        final methodCall = remoteDataSource.deleteAccount;

        // Assert
        expect(
          methodCall(password: testPassword),
          completes,
        );
      },
    );

    test(
      'given AuthRemoteDataSourceImpl, '
      'when [AuthRemoteDataSourceImpl.deleteAccount] is called '
      'and [FirebaseAuthException] is thrown '
      'then throw [DeleteAccountException] ',
      () async {
        // Arrange
        when(
          () => mockUser.reauthenticateWithCredential(any()),
        ).thenThrow(testFirebaseAuthException);

        // Act
        final methodCall = remoteDataSource.deleteAccount;

        // Assert
        expect(
          () async => methodCall(password: testPassword),
          throwsA(isA<DeleteAccountException>()),
        );
      },
    );
  });

  group('signOut - ', () {
    test(
        'given AuthRemoteDataSourceImpl '
        'when [AuthRemoteDataSourceImpl.signOut] is called '
        'and no [Exception] is thrown '
        'then complete successfully', () async {
      when(() => authClient.signOut()).thenAnswer((_) async => Future.value());

      final methodCall = remoteDataSource.signOut;

      expect(methodCall(), completes);
      verify(() => authClient.signOut()).called(1);
    });

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.signOut] '
      'call is unsuccessful '
      'and [FirebaseAuthException] is thrown '
      'then throw [SignOutException] ',
      () async {
        when(
          () => authClient.signOut(),
        ).thenThrow(testFirebaseAuthException);

        final methodCall = remoteDataSource.signOut;
        expect(
          () async => methodCall(),
          throwsA(isA<SignOutException>()),
        );
        verify(
          () => authClient.signOut(),
        ).called(1);
      },
    );
  });

  group('forgotPassword - ', () {
    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.forgotPassword] is called '
      'and no [Exception] is thrown '
      'then complete successfully ',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenAnswer((invocation) async => Future.value());

        final methodCall = remoteDataSource.forgotPassword(
          email: testUserModel.email,
        );
        expect(methodCall, completes);
        verify(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).called(1);
      },
    );

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.forgotPassword] '
      'call is unsuccessful '
      'and [FirebaseAuthException] is thrown '
      'then throw [ForgotPasswordException] ',
      () async {
        when(
          () => authClient.sendPasswordResetEmail(email: any(named: 'email')),
        ).thenThrow(testFirebaseAuthException);

        final methodCall = remoteDataSource.forgotPassword;
        expect(
          () async => methodCall(email: testUserModel.email),
          throwsA(
            isA<ForgotPasswordException>(),
          ),
        );
        verify(
          () => authClient.sendPasswordResetEmail(
            email: any(named: 'email'),
          ),
        ).called(1);
      },
    );
  });

  group('signIn - ', () {
    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.signIn] is called '
      'then return [UserEntity]',
      () async {
        // Arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => userCredential);

        // Act
        final result = await remoteDataSource.signIn(
          email: testUserModel.email,
          password: testPassword,
        );

        // Assert
        expect(result.uid, userCredential.user!.uid);
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.signIn] call is unsuccessful '
      'And [FirebaseAuthException] is thrown '
      'then throw [SignInException]',
      () async {
        // Arrange
        when(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(testFirebaseAuthException);

        // Act
        final methodCall = remoteDataSource.signIn;

        // Assert
        expect(
          () async => methodCall(
            email: testUserModel.email,
            password: testPassword,
          ),
          throwsA(isA<SignInException>()),
        );
        verify(
          () => authClient.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );
  });

  group('updateUser - ', () {
    setUp(() {
      mockUser = MockUser()..uid = userDocRef.id;
      registerFallbackValue(MockAuthCredential());
    });

    const testEmail = 'newEmail@mail.com';
    const testName = 'New Name';

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.updateUser] is called '
      'and action is [UpdateUserAction.name] '
      'then update user displayName and complete successfully ',
      () async {
        // Arrange
        when(
          () => mockUser.updateDisplayName(
            any(),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        await remoteDataSource.updateUser(
          action: UpdateUserAction.name,
          userData: testName,
        );

        // Assert
        verify(() => mockUser.updateDisplayName(testName)).called(1);

        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final userData = await firestoreClient
            .collection(FirebaseConstants.usersCollection)
            .doc(
              userDocRef.id,
            )
            .get();

        expect(userData.data()!['name'], testName);
      },
    );

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.updateUser] is called '
      'and action is [UpdateUserAction.email] '
      'then update user email and complete successfully ',
      () async {
        // Arrange
        when(
          () => mockUser.verifyBeforeUpdateEmail(
            any(),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        await remoteDataSource.updateUser(
          action: UpdateUserAction.email,
          userData: testEmail,
        );

        // Assert
        verify(() => mockUser.verifyBeforeUpdateEmail(testEmail)).called(1);

        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePassword(any()));

        final userData = await firestoreClient
            .collection(FirebaseConstants.usersCollection)
            .doc(
              userDocRef.id,
            )
            .get();

        expect(userData.data()?['email'], testEmail);
      },
    );

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.updateUser] is called '
      'and action is [UpdateUserAction.password] '
      'then update user password and complete successfully ',
      () async {
        when(
          () => mockUser.updatePassword(any()),
        ).thenAnswer((_) async => Future.value());

        when(
          () => mockUser.reauthenticateWithCredential(any()),
        ).thenAnswer((_) async => userCredential);

        when(() => mockUser.email).thenReturn(testEmail);

        await remoteDataSource.updateUser(
          action: UpdateUserAction.password,
          userData: jsonEncode({
            'oldPassword': 'oldPassword',
            'newPassword': testPassword,
          }),
        );

        verify(() => mockUser.updatePassword(testPassword)).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePhotoURL(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));

        final userData = await firestoreClient
            .collection(
              FirebaseConstants.usersCollection,
            )
            .doc(userDocRef.id)
            .get();

        expect(userData.data()!['password'], null);
      },
    );

    test(
      'given AuthRemoteDataSourceImpl '
      'when [AuthRemoteDataSourceImpl.updateUser] is called '
      'and action is [UpdateUserAction.photoUrl] '
      'then update user photoUrl and complete successfully ',
      () async {
        final newProfilePic = File('assets/images/onBoarding_background.png');

        when(
          () => mockUser.updatePhotoURL(
            any(),
          ),
        ).thenAnswer((_) async => Future.value());

        await remoteDataSource.updateUser(
          action: UpdateUserAction.profilePictureUrl,
          userData: newProfilePic,
        );

        verify(() => mockUser.updatePhotoURL(any())).called(1);

        verifyNever(() => mockUser.updateDisplayName(any()));
        verifyNever(() => mockUser.updatePassword(any()));
        verifyNever(() => mockUser.verifyBeforeUpdateEmail(any()));

        expect(storageClient.storedFilesMap.isNotEmpty, isTrue);
      },
    );
  });
}
