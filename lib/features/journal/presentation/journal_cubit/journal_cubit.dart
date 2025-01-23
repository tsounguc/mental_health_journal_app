import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/errors/failures.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/create_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/delete_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/get_journal_entries.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/update_journal_entry.dart';

part 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit({
    required CreateJournalEntry createJournalEntry,
    required DeleteJournalEntry deleteJournalEntry,
    required UpdateJournalEntry updateJournalEntry,
    required GetJournalEntries getJournalEntries,
  })  : _createJournalEntry = createJournalEntry,
        _deleteJournalEntry = deleteJournalEntry,
        _updateJournalEntry = updateJournalEntry,
        _getJournalEntries = getJournalEntries,
        super(JournalInitial());

  final CreateJournalEntry _createJournalEntry;
  final DeleteJournalEntry _deleteJournalEntry;
  final UpdateJournalEntry _updateJournalEntry;
  final GetJournalEntries _getJournalEntries;

  Future<void> createEntry({required JournalEntry entry}) async {
    emit(const JournalLoading());

    final result = await _createJournalEntry(entry);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (success) => emit(const EntryCreated()),
    );
  }

  Future<void> deleteEntry({required String entryId}) async {
    emit(const JournalLoading());

    final result = await _deleteJournalEntry(entryId);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (success) => emit(const EntryDeleted()),
    );
  }

  Future<void> updateEntry({
    required String entryId,
    required UpdateEntryAction action,
    required dynamic entryData,
  }) async {
    emit(const JournalLoading());

    final result = await _updateJournalEntry(
      UpdateJournalEntryParams(
        entryId: entryId,
        action: action,
        entryData: entryData,
      ),
    );

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (success) => emit(const EntryUpdated()),
    );
  }

  StreamSubscription<Either<Failure, List<JournalEntry>>>? subscription;
  List<JournalEntry> _entriesList = [];
  JournalEntry? _lastEntry;
  bool _hasReachedEnd = false;

  void getEntries({required String userId, bool loadMore = false}) {
    if (_hasReachedEnd && loadMore) return;

    emit(const JournalLoading());

    subscription?.cancel();

    subscription = _getJournalEntries(
      GetJournalEntriesParams(
        userId: userId,
        lastEntry: loadMore ? _lastEntry : null,
        paginationSize: 10,
      ),
    ).listen(
      (result) {
        result.fold(
          (failure) {
            debugPrint(failure.message);
            emit(JournalError(message: failure.message));
            subscription?.cancel();
          },
          (entries) async {
            if (loadMore) {
              _entriesList.addAll(entries);
            } else {
              _entriesList = entries;
            }

            _hasReachedEnd = entries.isEmpty || entries.length < 10;

            if (entries.isNotEmpty) {
              _lastEntry = entries.last;
            }

            emit(
              EntriesFetched(
                entries: _entriesList,
                hasReachedEnd: _hasReachedEnd,
              ),
            );
          },
        );
      },
      onError: (dynamic error) {
        emit(
          const JournalError(
            message: 'Failed to fetch entries',
          ),
        );
      },
      onDone: () {
        subscription?.cancel();
      },
    );
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
