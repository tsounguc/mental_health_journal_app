import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/data/models/journal_entry_model.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';

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

  final timestamp = Timestamp.fromDate(date);

  final testJson = fixture('journal_entry.json');
  final testMap = jsonDecode(testJson) as DataMap;
  testMap['dateCreated'] = timestamp;
  final testJournalEntryModel = JournalEntryModel.fromMap(testMap);
  test(
    'given [JournalEntryModel], '
    'when instantiated '
    'then instance should a subclass of [JournalEntry] ',
    () async {
      // Arrange
      // Act
      // Assert
      expect(testJournalEntryModel, isA<JournalEntry>());
    },
  );

  group('fromMap - ', () {
    test(
      'given [JournalEntryModel] '
      'when fromMap is called '
      'then return [JournalEntryModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = JournalEntryModel.fromMap(testMap);

        // Assert
        expect(result, isA<JournalEntryModel>());
        expect(result, equals(testJournalEntryModel));
      },
    );
  });

  group('toMap - ', () {
    test(
      'given [JournalEntryModel] '
      'when toMap is called '
      'then return [Map] with correct data',
      () {
        // Arrange

        // Act
        final result = testJournalEntryModel.toMap();
        // Assert
        expect(result, equals(testMap));
      },
    );
  });

  group('copyWith - ', () {
    const testContent = 'Today was a great day';
    test(
      'given [JournalEntryModel], '
      'when fromMap is called, '
      'then return [UserModel] with correct data ',
      () {
        // Arrange
        // Act
        final result = testJournalEntryModel.copyWith(content: testContent);
        // Assert
        expect(result.content, equals(testContent));
      },
    );
  });
}
