import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/notifications/data/models/notification_model.dart';
import 'package:mental_health_journal_app/features/notifications/domain/entities/notification_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date = DateTime.fromMillisecondsSinceEpoch(
    timestampData['_seconds']!,
  ).add(
    Duration(microseconds: timestampData['_nanoseconds']!),
  );

  // final timestamp = Timestamp.fromDate(date);

  final testJson = fixture('notification.json');
  final testMap = jsonDecode(testJson) as DataMap;
  testMap['scheduledTime'] = date;

  final testNotificationModel = NotificationModel.fromMap(testMap);

  test(
    'given [NotificationModel], '
    'when instantiated '
    'then instance should be a subclass of [NotificationModel] ',
    () async {
      // Arrange
      // Act
      // Assert
      expect(testNotificationModel, isA<NotificationEntity>());
    },
  );

  group('fromMap - ', () {
    test(
      'given [NotificationModel] '
      'when fromMap is called '
      'then return [NotificationModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = NotificationModel.fromMap(testMap);

        // Assert
        expect(result, isA<NotificationModel>());
        expect(result.id, equals(testNotificationModel.id));
        expect(result.title, equals(testNotificationModel.title));
        expect(result.body, equals(testNotificationModel.body));
      },
    );
  });

  group('toMap - ', () {
    test(
      'given [NotificationModel] '
      'when toMap is called '
      'then return [Map] with correct data',
      () {
        // Arrange

        // Act
        final result = testNotificationModel.toMap();
        // Assert
        expect(result['id'], equals(testMap['id']));
        expect(result['title'], equals(testMap['title']));
        expect(result['body'], equals(testMap['body']));
      },
    );
  });

  group('copyWith - ', () {
    const testBody = 'test notification body';
    test(
      'given [JournalEntryModel], '
      'when fromMap is called, '
      'then return [NotificationModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = testNotificationModel.copyWith(body: testBody);
        // Assert
        expect(result.body, equals(testBody));
      },
    );
  });
}
