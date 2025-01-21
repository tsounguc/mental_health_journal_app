import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/core/utils/firebase_constants.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';

class DashboardUtils {
  const DashboardUtils._();

  static Stream<UserModel> get userDataStream => serviceLocator<FirebaseFirestore>()
      .collection(FirebaseConstants.usersCollection)
      .doc(serviceLocator<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map(
        (event) => UserModel.fromMap(event.data()!),
      );
}
