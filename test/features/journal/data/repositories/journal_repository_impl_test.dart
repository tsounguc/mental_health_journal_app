import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/data/data_sources/journal_remote_data_source.dart';
import 'package:mental_health_journal_app/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/repositories/journal_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalRemoteDataSource extends Mock implements JournalRemoteDataSource {}

void main() {
  late JournalRemoteDataSource remoteDataSource;
  late JournalRepositoryImpl repositoryImpl;

  final testEntry = JournalEntry.empty();

  setUp(() {
    remoteDataSource = MockJournalRemoteDataSource();
    repositoryImpl = JournalRepositoryImpl(remoteDataSource);
    registerFallbackValue(UpdateEntryAction.content);
    registerFallbackValue(testEntry);
  });

  test(
    'given JournalRepositoryImpl '
    'when instantiated '
    'then instance should be a subclass of [JournalRepository]',
    () async {
      // Arrange
      // Act
      // Assert
      expect(repositoryImpl, isA<JournalRepository>());
    },
  );

  group('createEntry - ', () {
    test(
      'given JournalRepositoryImpl, '
      'when [JournalRemoteDataSource.createEntry] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.createEntry(entry: any(named: 'entry')),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.createEntry(entry: testEntry);

        // Assert
        expect(
          result,
          const Right<Failure, void>(null),
        );

        verify(
          () => remoteDataSource.createEntry(entry: testEntry),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'given JournalRepositoryImpl, '
      'when [JournalRemoteDataSource.createEntry] called is unsuccessful '
      'then return [CreateEntryFailure]',
      () async {
        // Arrange
        const testCreateEntryException = CreateEntryException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.createEntry(
            entry: any(named: 'entry'),
          ),
        ).thenThrow(testCreateEntryException);

        // Act
        final result = await repositoryImpl.createEntry(
          entry: testEntry,
        );

        // Assert
        expect(
          result,
          Left<Failure, void>(
            CreateEntryFailure.fromException(
              testCreateEntryException,
            ),
          ),
        );

        verify(
          () => remoteDataSource.createEntry(
            entry: testEntry,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('deleteEntry - ', () {
    test(
      'given JournalRepositoryImpl, '
      'when [JournalRemoteDataSource.deleteEntry] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.deleteEntry(entryId: any(named: 'entryId')),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.deleteEntry(id: testEntry.id);

        // Assert
        expect(
          result,
          const Right<Failure, void>(null),
        );

        verify(
          () => remoteDataSource.deleteEntry(entryId: testEntry.id),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'given JournalRepositoryImpl, '
      'when [JournalRemoteDataSource.deleteEntry] called is unsuccessful '
      'then return [DeleteEntryFailure]',
      () async {
        // Arrange
        const testDeleteEntryException = DeleteEntryException(
          message: 'message',
          statusCode: '500',
        );
        when(
          () => remoteDataSource.deleteEntry(
            entryId: any(named: 'entryId'),
          ),
        ).thenThrow(testDeleteEntryException);

        // Act
        final result = await repositoryImpl.deleteEntry(
          id: testEntry.id,
        );

        // Assert
        expect(
          result,
          Left<Failure, void>(
            DeleteEntryFailure.fromException(
              testDeleteEntryException,
            ),
          ),
        );

        verify(
          () => remoteDataSource.deleteEntry(
            entryId: testEntry.id,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('updateEntry', () {
    const testEntryData = 'Today was a great day';
    const testAction = UpdateEntryAction.content;
    test(
      'given JournalRepositoryImpl, '
      'when [JournalRemoteDataSource.updateEntry] is called '
      'then return [void]',
      () async {
        // Arrange
        when(
          () => remoteDataSource.updateEntry(
            entryId: any(named: 'entryId'),
            action: any(named: 'action'),
            entryData: any<dynamic>(named: 'entryData'),
          ),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await repositoryImpl.updateEntry(
          entryId: testEntry.id,
          action: testAction,
          entryData: testEntryData,
        );

        // Assert
        expect(result, const Right<Failure, void>(null));

        verify(
          () => remoteDataSource.updateEntry(
            entryId: testEntry.id,
            action: testAction,
            entryData: testEntryData,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'given JournalRepositoryImpl, '
      'when [JournalRemoteDataSource.updateEntry] called is unsuccessful '
      'then return [UpdateEntryFailure]',
      () async {
        // Arrange
        const testUpdateEntryException = UpdateEntryException(
          message: 'message',
          statusCode: '500',
        );

        when(
          () => remoteDataSource.updateEntry(
            entryId: any(named: 'entryId'),
            action: any(named: 'action'),
            entryData: any<dynamic>(named: 'entryData'),
          ),
        ).thenThrow(testUpdateEntryException);

        // Act
        final result = await repositoryImpl.updateEntry(
          entryId: testEntry.id,
          action: testAction,
          entryData: testEntryData,
        );

        // Assert
        expect(
          result,
          Left<Failure, void>(
            UpdateEntryFailure.fromException(testUpdateEntryException),
          ),
        );

        verify(
          () => remoteDataSource.updateEntry(
            entryId: testEntry.id,
            action: testAction,
            entryData: testEntryData,
          ),
        ).called(1);

        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
