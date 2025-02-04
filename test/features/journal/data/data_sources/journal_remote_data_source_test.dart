import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/exceptions.dart';
import 'package:mental_health_journal_app/core/utils/firebase_constants.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/journal/data/data_sources/journal_remote_data_source.dart';
import 'package:mental_health_journal_app/features/journal/data/models/journal_entry_model.dart';
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

void main() {
  late FirebaseAuth authClient;

  late FakeFirebaseFirestore firestoreClient;

  late JournalRemoteDataSourceImpl remoteDataSourceImpl;

  late DocumentReference<DataMap> userDocRef;

  late MockUser mockFirebaseUser;

  final testUser = UserModel.empty();

  var testEntry = JournalEntryModel.empty();

  final testEntries = [
    JournalEntryModel.empty(),
    JournalEntryModel.empty().copyWith(id: '1'),
  ];

  final testFirebaseAuthException = FirebaseAuthException(
    code: 'user-not-found',
    message: 'There is no user record corresponding to this identifier.',
  );

  setUpAll(() async {
    authClient = MockFirebaseAuth();
    firestoreClient = FakeFirebaseFirestore();

    userDocRef = firestoreClient
        .collection(
          FirebaseConstants.usersCollection,
        )
        .doc();

    await userDocRef.set(
      testUser.copyWith(uid: userDocRef.id).toMap(),
    );

    mockFirebaseUser = MockUser()..uid = userDocRef.id;

    remoteDataSourceImpl = JournalRemoteDataSourceImpl(
      authClient: authClient,
      firestoreClient: firestoreClient,
    );

    when(() => authClient.currentUser).thenAnswer((_) => mockFirebaseUser);

    registerFallbackValue(testEntry);
  });

  test(
    'given JournalRemoteDataSourceImpl '
    'when instantiated '
    'then instance should be a subclass of [JournalRemoteDataSource]',
    () {
      // Arrange
      // Act
      // Assert
      expect(remoteDataSourceImpl, isA<JournalRemoteDataSource>());
    },
  );

  group('createEntry - ', () {
    test(
      'given JournalRemoteDataSourceImpl, '
      'when [JournalRemoteDataSourceImpl.createEntry] is called '
      'then add the given entry to firestore entries collection',
      () async {
        // Arrange

        // Act
        await remoteDataSourceImpl.createEntry(entry: testEntry);

        // Assert
        final entriesCollectionRef = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .get();
        expect(entriesCollectionRef.docs.length, 1);

        final entryDocRef = entriesCollectionRef.docs.first;
        testEntry = testEntry.copyWith(id: entryDocRef.id);
        expect(entryDocRef.data()['id'], entryDocRef.id);

        testEntry = testEntry.copyWith(userId: userDocRef.id);
        expect(entryDocRef.data()['userId'], userDocRef.id);
      },
    );

    test(
      'given JournalRemoteDataSourceImpl, '
      'when [JournalRemoteDataSourceImpl.createEntry] is called '
      'and [FirebaseAuthException] is thrown '
      'then throw [CreateEntryException]',
      () async {
        // Arrange
        when(
          () => authClient.currentUser?.uid,
        ).thenThrow(testFirebaseAuthException);
        // Act
        final methodCall = remoteDataSourceImpl.createEntry;

        // Assert
        expect(
          () => methodCall(entry: testEntry),
          throwsA(isA<CreateEntryException>()),
        );
      },
    );
  });

  group('updateEntry - ', () {
    test(
      'given JournalRemoteDataSourceImpl '
      'when [JournalRemoteDataSourceImpl.updateEntry] is called '
      'and entry action is [UpdateEntryAction.title] '
      'then update entry and complete successfully',
      () async {
        // Arrange
        const testTitle = 'New Title';

        // Act
        await remoteDataSourceImpl.updateEntry(
          entryId: testEntry.id,
          action: UpdateEntryAction.title,
          entryData: testTitle,
        );

        // Assert
        final entryData = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .doc(testEntry.id)
            .get();

        expect(entryData.data()!['title'], testTitle);
      },
    );

    test(
      'given JournalRemoteDataSourceImpl '
      'when [JournalRemoteDataSourceImpl.updateEntry] is called '
      'and entry action is [UpdateEntryAction.content] '
      'then update entry and complete successfully',
      () async {
        // Arrange
        const testContent = {
          'content': 'New content',
          'sentimentScore': 0.0,
        };

        // Act
        await remoteDataSourceImpl.updateEntry(
          entryId: testEntry.id,
          action: UpdateEntryAction.content,
          entryData: testContent,
        );

        // Assert
        final entryData = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .doc(testEntry.id)
            .get();

        expect(entryData.data()!['content'], testContent['content']);
      },
    );

    test(
      'given JournalRemoteDataSourceImpl '
      'when [JournalRemoteDataSourceImpl.updateEntry] is called '
      'and entry action is [UpdateEntryAction.tags] '
      'then update entry and complete successfully',
      () async {
        // Arrange
        const testTags = ['Happy'];

        // Act
        await remoteDataSourceImpl.updateEntry(
          entryId: testEntry.id,
          action: UpdateEntryAction.tags,
          entryData: testTags,
        );

        // Assert
        final entryData = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .doc(testEntry.id)
            .get();

        expect(entryData.data()!['tags'], testTags);
      },
    );

    test(
      'given JournalRemoteDataSourceImpl '
      'when [JournalRemoteDataSourceImpl.updateEntry] is called '
      'and entry action is [UpdateEntryAction.sentiment] '
      'then update entry and complete successfully',
      () async {
        // Arrange
        const testSentimentScore = 'Angry';

        // Act
        await remoteDataSourceImpl.updateEntry(
          entryId: testEntry.id,
          action: UpdateEntryAction.selectedMood,
          entryData: testSentimentScore,
        );

        // Assert
        final entryData = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .doc(testEntry.id)
            .get();

        expect(entryData.data()!['selectedMood'], testSentimentScore);
      },
    );
  });

  group('deleteEntry - ', () {
    test(
      'given JournalRemoteDataSourceImpl, '
      'when [JournalRemoteDataSourceImpl.deleteEntry] is called '
      'then delete entry and complete successful',
      () async {
        // Arrange

        // Act
        await remoteDataSourceImpl.deleteEntry(entryId: testEntry.id);

        // Assert
        final entriesCollectionRef = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .get();
        expect(entriesCollectionRef.docs.length, 0);
      },
    );
  });

  group('getEntries - ', () {
    test(
      'given JournalRemoteDataSourceImpl '
      'when [JournalRemoteDataSourceImpl.getEntries] is called '
      'then return [Stream<List<JournalEntry>>]',
      () async {
        // Arrange
        for (final entry in testEntries) {
          await firestoreClient
              .collection(
                FirebaseConstants.entriesCollection,
              )
              .add(entry.toMap());
        }

        // Act
        remoteDataSourceImpl.getEntries(
          userId: testEntry.userId,
          lastEntry: testEntry,
          paginationSize: 10,
        );

        // Assert
        final entriesCollectionRef = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .get();

        expect(entriesCollectionRef.docs.length, 2);
        expect(
          entriesCollectionRef.docs.first.data()['id'],
          testEntries[0].id,
        );
      },
    );
  });

  group('getDashboardData - ', () {
    test(
      'given JournalRemoteDataSourceImpl '
      'when [JournalRemoteDataSourceImpl.getDashboardData] is called '
      'then return [Stream<List<JournalEntry>>]',
      () async {
        // Arrange
        final today = DateTime.now();
        // Act
        remoteDataSourceImpl.getDashboardData(
          userId: testEntry.userId,
          today: today,
        );

        // Assert
        final entriesCollectionRef = await firestoreClient
            .collection(
              FirebaseConstants.entriesCollection,
            )
            .get();

        expect(entriesCollectionRef.docs.length, 2);
        expect(
          entriesCollectionRef.docs.first.data()['id'],
          testEntries[0].id,
        );
      },
    );
  });
}
