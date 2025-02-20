import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/utils/typedefs.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';

abstract class JournalRepository {
  const JournalRepository();

  ResultVoid createEntry({
    required JournalEntry entry,
  });
  ResultVoid updateEntry({
    required String entryId,
    required UpdateEntryAction action,
    required dynamic entryData,
  });

  ResultVoid deleteEntry({required String id});

  ResultFuture<List<JournalEntry>> searchEntries(String query);

  ResultStream<List<JournalEntry>> getEntries({
    required String userId,
    required JournalEntry? lastEntry,
    required int paginationSize,
  });

  ResultStream<List<JournalEntry>> getDashboardData({
    required String userId,
    required DateTime range,
  });
}
