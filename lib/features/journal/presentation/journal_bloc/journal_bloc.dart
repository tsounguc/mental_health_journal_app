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

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc({
    required CreateJournalEntry createJournalEntry,
    required DeleteJournalEntry deleteJournalEntry,
    required UpdateJournalEntry updateJournalEntry,
    required GetJournalEntries getJournalEntries,
  })  : _createJournalEntry = createJournalEntry,
        _deleteJournalEntry = deleteJournalEntry,
        _updateJournalEntry = updateJournalEntry,
        _getJournalEntries = getJournalEntries,
        super(const JournalInitial()) {
    on<CreateEntryEvent>(_createEntryHandler);
    on<DeleteEntryEvent>(_deleteEntryHandler);
    on<UpdateEntryEvent>(_updateEntryHandler);
    on<FetchEntriesEvent>(_getEntriesHandler);
  }

  final CreateJournalEntry _createJournalEntry;
  final DeleteJournalEntry _deleteJournalEntry;
  final UpdateJournalEntry _updateJournalEntry;
  final GetJournalEntries _getJournalEntries;

  List<JournalEntry> _entriesList = [];

  Future<void> _createEntryHandler(
    CreateEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await _createJournalEntry(event.entry);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (success) => emit(const EntryCreated()),
    );
  }

  Future<void> _deleteEntryHandler(
    DeleteEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await _deleteJournalEntry(event.entryId);

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (success) => emit(const EntryDeleted()),
    );
  }

  Future<void> _updateEntryHandler(
    UpdateEntryEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await _updateJournalEntry(
      UpdateJournalEntryParams(
        entryId: event.entryId,
        action: event.action,
        entryData: event.entryData,
      ),
    );

    result.fold(
      (failure) => emit(JournalError(message: failure.message)),
      (success) => emit(const EntryUpdated()),
    );
  }

  Future<void> _getEntriesHandler(
    FetchEntriesEvent event,
    Emitter<JournalState> emit,
  ) async {
    emit(const JournalLoading());
    StreamSubscription<Either<Failure, List<JournalEntry>>>? subscription;
    try {
      subscription = _getJournalEntries(
        GetJournalEntriesParams(
          userId: event.userId,
          lastEntry: event.lastEntry,
          paginationSize: event.paginationSize,
        ),
      ).listen(
        (result) async {
          if (emit.isDone) {
            await subscription?.cancel();
            return;
          }

          await result.fold(
            (failure) async {
              debugPrint(failure.message);
              if (!emit.isDone) {
                emit(JournalError(message: failure.message));
              }
              await subscription?.cancel();
            },
            (entries) async {
              if (emit.isDone) {
                return;
              }

              if (entries.isEmpty) {
                emit(
                  EntriesFetched(
                    entries: entries,
                    hasReachedEnd: true,
                  ),
                );
              } else if (entries.isNotEmpty) {
                final hasReachedEnd = entries.length < 10;

                _entriesList = state is EntriesFetched ? (state as EntriesFetched).entries + entries : entries;

                if (!emit.isDone) {
                  emit(
                    EntriesFetched(
                      entries: _entriesList,
                      hasReachedEnd: hasReachedEnd,
                    ),
                  );
                }
              }
            },
          );
        },
        onError: (dynamic error) async {
          if (!emit.isDone) {
            emit(
              const JournalError(
                message: 'Failed to fetch entries',
              ),
            );
          }
        },
        onDone: () async {
          await subscription?.cancel();
        },
      );
      // await subscription.asFuture<Either<Failure, List<JournalEntry>>>();
    } on Exception catch (error) {
      if (!emit.isDone) {
        emit(
          JournalError(
            message: error.toString(),
          ),
        );
      }
    }
  }
}
