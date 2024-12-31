import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final testJson = fixture('user.json');
  print(testJson);
  final testUserModel = UserModel.fromJson(testJson);
  print(testUserModel);
  // final testMap = jsonDecode(testJson) as DataMap;
  final testMap = testUserModel.toMap();
  print(testMap);

  // testMap['dateCreated'] = timestamp;

  test(
    'given [UserModel], '
    'when instantiated '
    'then instance should a subclass of [UserEntity] ',
    () async {
      // Arrange
      // Act
      // Assert
      expect(testUserModel, isA<UserEntity>());
    },
  );

  group('fromJson - ', () {
    test(
      'given [UserModel], '
      'when fromJson is called, '
      'then return [UserModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = UserModel.fromJson(testJson);
        // Assert
        expect(result, isA<UserModel>());
        expect(result, equals(testUserModel));
      },
    );
  });

  group('fromMap - ', () {
    test(
      'given [UserModel] '
      'when fromMap is called '
      'then return [UserModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = UserModel.fromMap(testMap);
        // Assert
        expect(result, isA<UserModel>());
        expect(result, equals(testUserModel));
      },
    );
  });

  group('toMap - ', () {
    test(
      'given [UserModel] '
      'when toMap is called '
      'then return [Map] with correct data',
      () {
        // Arrange

        // Act
        final result = testUserModel.toMap();
        // Assert
        expect(result, equals(testMap));
      },
    );
  });

  group('copyWith - ', () {
    const testName = 'John Doe';
    test(
      'given [UserModel], '
      'when fromMap is called, '
      'then return [UserModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = testUserModel.copyWith(name: testName);
        // Assert
        expect(result.name, equals(testName));
      },
    );
  });
}
