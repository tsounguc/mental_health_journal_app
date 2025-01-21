import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mental_health_journal_app/core/common/views/long_button.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/data/models/journal_entry_model.dart';
import 'package:mental_health_journal_app/features/journal/domain/entities/journal_entry.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/journal_form_field.dart';

class JournalEditorScreen extends StatefulWidget {
  const JournalEditorScreen({super.key, this.entry});

  static const id = '/journal-editor';

  final JournalEntry? entry;

  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = QuillController.basic();
  final _tags = <String>[];
  String? _selectedMood;

  bool get titleEntered => _titleController.text.trim().isNotEmpty;

  bool get titleChanged => widget.entry!.title!.trim() != _titleController.text.trim();

  bool get contentEntered => _contentController.document.length > 1;

  bool get contentChanged =>
      Document.fromJson(jsonDecode(widget.entry!.content) as List).toPlainText() !=
      _contentController.document.toPlainText();

  bool get tagsChanged => widget.entry!.tags.length != _tags.length;

  bool get selectedMoodChanged =>
      widget.entry!.sentiment.capitalizeFirstLetter() != _selectedMood!.capitalizeFirstLetter();

  bool get canSubmit => titleEntered && contentEntered;

  bool get nothingChanged => !titleChanged && !contentChanged && !tagsChanged && !selectedMoodChanged;

  void _addTag(String tag) {
    setState(() {
      if (tag.isNotEmpty && !_tags.contains(tag)) {
        _tags.add(tag);
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitEntry() {
    final cubit = context.read<JournalCubit>();
    final entry = JournalEntryModel.empty().copyWith(
      userId: context.currentUser!.uid,
      title: _titleController.text.trim(),
      titleLowercase: _titleController.text.trim().toLowerCase(),
      content: jsonEncode(_contentController.document.toDelta().toJson()),
      sentiment: _selectedMood?.capitalizeFirstLetter(),
      tags: _tags,
    );
    if (context.currentUser == null) {
      CoreUtils.showSnackBar(context, 'User not logged in');
    } else {
      cubit.createEntry(
        entry: entry,
      );
    }
  }

  void saveChanges(BuildContext context) {
    if (nothingChanged) Navigator.pop(context);

    final cubit = context.read<JournalCubit>();

    if (titleChanged) {
      cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.title,
        entryData: _titleController.text.trim(),
      );
    }

    if (contentChanged) {
      cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.content,
        entryData: jsonEncode(_contentController.document.toDelta().toJson()),
      );
    }

    if (tagsChanged) {
      cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.tags,
        entryData: _tags,
      );
    }

    if (selectedMoodChanged) {
      cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.sentiment,
        entryData: _selectedMood,
      );
    }
  }

  @override
  void initState() {
    if (widget.entry != null) {
      _titleController.text = widget.entry!.title!;
      try {
        // Attempt to parse the content as Delta JSON
        final deltaJson = jsonDecode(widget.entry!.content);
        _contentController.document = Document.fromJson(deltaJson as List);
        _selectedMood = widget.entry!.sentiment.capitalizeFirstLetter();
        _tags.addAll(widget.entry!.tags);
      } on Exception catch (e) {
        // If parsing fails, treat the content as plain text
        debugPrint(e.toString());
        _contentController.document = Document()
          ..insert(
            0,
            widget.entry!.content,
          );
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JournalCubit, JournalState>(
      listener: (context, state) {
        if (state is EntryCreated) {
          CoreUtils.showSnackBar(context, 'Journal entry saved');
          Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          );
        } else if (state is EntryUpdated) {
          CoreUtils.showSnackBar(context, 'Journal entry saved');
          Navigator.popUntil(
            context,
            ModalRoute.withName('/'),
          );
        } else if (state is JournalError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.entry == null ? 'New Journal Entry' : 'Edit Journal Entry',
            ),
            surfaceTintColor: Colors.transparent,
            actions: [
              StatefulBuilder(
                builder: (context, refresh) {
                  _titleController.addListener(() => refresh(() {}));
                  _contentController.addListener(() => refresh(() {}));
                  return state is JournalLoading
                      ? const Center(child: CircularProgressIndicator())
                      : widget.entry != null
                          ? TextButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text(
                                'Save',
                                style: TextStyle(fontSize: 16),
                              ),
                              // color: context.theme.primaryColor,
                              onPressed: nothingChanged ? null : () => saveChanges(context),
                            )
                          : TextButton.icon(
                              icon: const Icon(Icons.check),
                              label: const Text(
                                'Save',
                                style: TextStyle(fontSize: 16),
                              ),
                              // color: context.theme.primaryColor,
                              onPressed: !canSubmit ? null : _submitEntry,
                            );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 25,
            ).copyWith(top: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  JournalFormField(
                    hintText: 'Title',
                    hintStyle: const TextStyle(
                      color: Colours.softGreyColor,
                      fontSize: 16,
                    ),
                    controller: _titleController,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  QuillSimpleToolbar(
                    controller: _contentController,
                    configurations: const QuillSimpleToolbarConfigurations(
                      multiRowsDisplay: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 10,
                    ).copyWith(top: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colours.softGreyColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: QuillEditor.basic(
                      controller: _contentController,
                      configurations: QuillEditorConfigurations(
                        minHeight: 250,
                        maxHeight: 250,
                        onTapOutside: (event, focusNode) {
                          focusNode.unfocus();
                        },
                        placeholder: 'Start writing your thoughts here..',
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Mood Selector',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedMood,
                    items: ['Happy', 'Sad', 'Angry', 'Neutral']
                        .map(
                          (mood) => DropdownMenuItem(
                            value: mood,
                            child: Text(mood),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMood = value;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colours.softGreyColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colours.softGreyColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colours.softGreyColor),
                      ),
                      hintText: 'Select Mood',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tags',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Wrap(
                    spacing: 8,
                    children: _tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            onDeleted: () => _removeTag(tag),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  JournalFormField(
                    fieldTitle: 'Add Tag',
                    onFieldSubmitted: _addTag,
                    borderRadius: BorderRadius.circular(12),
                    textInputAction: TextInputAction.send,
                  ),
                  StatefulBuilder(
                    builder: (context, refresh) {
                      _titleController.addListener(() => refresh(() {}));
                      _contentController.addListener(() => refresh(() {}));
                      return state is JournalLoading
                          ? const Center(child: CircularProgressIndicator())
                          : widget.entry != null
                              ? LongButton(
                                  onPressed: nothingChanged ? null : () => saveChanges(context),
                                  label: 'Save',
                                )
                              : LongButton(
                                  onPressed: !canSubmit ? null : _submitEntry,
                                  label: 'Save',
                                );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
