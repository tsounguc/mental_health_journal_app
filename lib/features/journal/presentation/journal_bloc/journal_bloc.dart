import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/create_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/delete_journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/domain/use_cases/update_journal_entry.dart';

part 'journal_event.dart';
part 'journal_state.dart';

class JournalBloc extends Bloc<JournalEvent, JournalState> {
  JournalBloc({
    required CreateJournalEntry createJournalEntry,
    required DeleteJournalEntry deleteJournalEntry,
    required UpdateJournalEntry updateJournalEntry,
  })  : _createJournalEntry = createJournalEntry,
        _deleteJournalEntry = deleteJournalEntry,
        _updateJournalEntry = updateJournalEntry,
        super(const JournalInitial()) {
    on<CreateEntryEvent>(_createEntryHandler);
    on<DeleteEntryEvent>(_deleteEntryHandler);
    on<UpdateEntryEvent>(_updateEntryHandler);
  }

  final CreateJournalEntry _createJournalEntry;
  final DeleteJournalEntry _deleteJournalEntry;
  final UpdateJournalEntry _updateJournalEntry;

  FutureOr<void> _createEntryHandler(
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

  FutureOr<void> _deleteEntryHandler(
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

  FutureOr<void> _updateEntryHandler(
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
}
