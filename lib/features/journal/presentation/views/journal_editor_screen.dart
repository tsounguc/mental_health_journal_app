import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:mental_health_journal_app/core/common/views/long_button.dart';
import 'package:mental_health_journal_app/core/enums/update_entry_action.dart';
import 'package:mental_health_journal_app/core/enums/update_user_action.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/services/sentiment_analyser.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/domain/entities/user.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
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
  final sentimentAnalyzer = SentimentAnalyzer();
  final _tags = <String>[];
  TagsFrequency? _newTagsFrequency;

  String? _selectedMood;

  bool get titleEntered => _titleController.text.trim().isNotEmpty;

  bool get titleChanged => widget.entry!.title!.trim() != _titleController.text.trim();

  bool get contentEntered => _contentController.document.length > 1;

  bool get contentChanged =>
      Document.fromJson(jsonDecode(widget.entry!.content) as List).toPlainText() !=
      _contentController.document.toPlainText();

  bool get tagsChanged => widget.entry!.tags.length != _tags.length;

  bool get selectedMoodChanged =>
      widget.entry!.selectedMood.capitalizeFirstLetter() != _selectedMood!.capitalizeFirstLetter();

  bool get canSubmit => titleEntered && contentEntered;

  bool get nothingChanged => !titleChanged && !contentChanged && !tagsChanged && !selectedMoodChanged;

  void _addTag(String tag) {
    setState(() {
      if (tag.isNotEmpty && !_tags.contains(tag)) {
        _tags.add(tag);
        _newTagsFrequency = _newTagsFrequency?.addTag(tag);
      }
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
      _newTagsFrequency = _newTagsFrequency?.removeTag(tag);
    });
  }

  void _submitEntry() async {
    final cubit = context.read<JournalCubit>();
    final bloc = context.read<AuthBloc>();

    final journalText = _contentController.document.toPlainText();

    final sentimentScore = await sentimentAnalyzer.analyzeText(journalText);

    final entry = JournalEntryModel.empty().copyWith(
      userId: context.currentUser!.uid,
      title: _titleController.text.trim(),
      titleLowercase: _titleController.text.trim().toLowerCase(),
      content: jsonEncode(_contentController.document.toDelta().toJson()),
      selectedMood: _selectedMood?.capitalizeFirstLetter(),
      sentimentScore: sentimentScore,
      tags: _tags,
    );
    if (context.currentUser == null) {
      CoreUtils.showSnackBar(context, 'User not logged in');
    } else {
      await cubit.createEntry(
        entry: entry,
      );

      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.totalEntries,
          userData: context.currentUser!.totalEntries + 1,
        ),
      );

      updateSentimentSummary(sentimentScore, context, bloc);
      updateMoodSummary(context, bloc);
      _newTagsFrequency = _newTagsFrequency?.addAllTags(_tags);
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.tagsFrequency,
          userData: _newTagsFrequency,
        ),
      );
    }
  }

  Future<void> saveChanges(BuildContext context) async {
    if (nothingChanged) Navigator.pop(context);

    final cubit = context.read<JournalCubit>();
    final bloc = context.read<AuthBloc>();
    if (titleChanged) {
      await cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.title,
        entryData: _titleController.text.trim(),
      );
    }

    if (contentChanged) {
      final journalText = _contentController.document.toPlainText();
      final sentimentScore = await sentimentAnalyzer.analyzeText(journalText);

      await cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.content,
        entryData: {
          'content': jsonEncode(_contentController.document.toDelta().toJson()),
          'sentimentScore': sentimentScore,
        },
      );
      updateSentimentSummary(sentimentScore, context, bloc);
    }

    if (tagsChanged) {
      await cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.tags,
        entryData: _tags,
      );
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.tagsFrequency,
          userData: _newTagsFrequency,
        ),
      );
    }

    if (selectedMoodChanged) {
      await cubit.updateEntry(
        entryId: widget.entry!.id,
        action: UpdateEntryAction.selectedMood,
        entryData: _selectedMood,
      );

      updateMoodSummary(context, bloc);
    }
  }

  @override
  void initState() {
    if (widget.entry != null) {
      _newTagsFrequency = context.currentUser!.tagsFrequency;
      _titleController.text = widget.entry!.title!;

      try {
        // Attempt to parse the content as Delta JSON
        final deltaJson = jsonDecode(widget.entry!.content);
        _contentController.document = Document.fromJson(deltaJson as List);
        _selectedMood = widget.entry!.selectedMood.capitalizeFirstLetter();
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

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
    ]);
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
          backgroundColor: Colours.backgroundColor,
          appBar: AppBar(
            backgroundColor: Colours.backgroundColor,
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
                              onPressed: nothingChanged
                                  ? null
                                  : () => saveChanges(
                                        context,
                                      ),
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
                  JournalFormField(
                    hintText: 'Title',
                    hintStyle: const TextStyle(
                      color: Colours.softGreyColor,
                      fontSize: 16,
                    ),
                    fillColor: Colours.backgroundColor,
                    controller: _titleController,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  QuillSimpleToolbar(
                    controller: _contentController,
                    configurations: QuillSimpleToolbarConfigurations(
                      toolbarIconCrossAlignment: WrapCrossAlignment.start,
                      decoration: BoxDecoration(
                        color: Colours.softGreyColor.withValues(
                          alpha: 0.09,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      multiRowsDisplay: false,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ).copyWith(bottom: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colours.softGreyColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QuillEditor.basic(
                      controller: _contentController,
                      configurations: QuillEditorConfigurations(
                        minHeight: 375,
                        maxHeight: 375,
                        onTapOutside: (event, focusNode) {
                          focusNode.unfocus();
                        },
                        placeholder: 'Start writing your thoughts here..',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField<String>(
                      hint: const Text(
                        'Select Mood',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colours.softGreyColor,
                        ),
                      ),
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
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colours.softGreyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colours.softGreyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Colours.softGreyColor,
                          ),
                        ),
                        // hintText: 'Select Mood',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colours.softGreyColor.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  JournalFormField(
                    hintText: 'Add Tag',
                    onFieldSubmitted: _addTag,
                    borderRadius: BorderRadius.circular(8),
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
                                  onPressed: nothingChanged
                                      ? null
                                      : () => saveChanges(
                                            context,
                                          ),
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

  void updateSentimentSummary(
    double sentimentScore,
    BuildContext context,
    AuthBloc bloc,
  ) {
    final user = context.currentUser!;
    final sentimentSummary = user.sentimentSummary as SentimentSummaryModel;
    final previousInterpretation = widget.entry == null
        ? ''
        : sentimentAnalyzer.interpretResult(
            widget.entry!.sentimentScore,
          );
    final interpretation = sentimentAnalyzer.interpretResult(
      sentimentScore,
    );
    final isNegativeScore = interpretation == 'Negative';
    final isPositiveScore = interpretation == 'Positive';
    final isNeutralScore = interpretation == 'Neutral';

    if (widget.entry == null) {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.sentimentSummary,
          userData: sentimentSummary.copyWith(
            negative: isNegativeScore ? sentimentSummary.negative + 1 : null,
            positive: isPositiveScore ? sentimentSummary.positive + 1 : null,
            neutral: isNeutralScore ? sentimentSummary.neutral + 1 : null,
          ),
        ),
      );
    }
    if (previousInterpretation == 'Positive') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.sentimentSummary,
          userData: sentimentSummary.copyWith(
            positive: sentimentSummary.positive > 0 ? sentimentSummary.positive - 1 : 0,
            neutral: isNeutralScore ? sentimentSummary.neutral + 1 : null,
            negative: isNegativeScore ? sentimentSummary.negative + 1 : null,
          ),
        ),
      );
    }
    if (previousInterpretation == 'Negative') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.sentimentSummary,
          userData: sentimentSummary.copyWith(
            negative: sentimentSummary.negative > 0 ? sentimentSummary.negative - 1 : 0,
            positive: isPositiveScore ? sentimentSummary.positive + 1 : null,
            neutral: isNeutralScore ? sentimentSummary.neutral + 1 : null,
          ),
        ),
      );
    }
    if (previousInterpretation == 'Neutral') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.sentimentSummary,
          userData: sentimentSummary.copyWith(
            neutral: sentimentSummary.neutral > 0 ? sentimentSummary.neutral - 1 : 0,
            positive: isPositiveScore ? sentimentSummary.positive + 1 : null,
            negative: isNegativeScore ? sentimentSummary.negative + 1 : null,
          ),
        ),
      );
    }
  }

  void updateMoodSummary(BuildContext context, AuthBloc bloc) {
    final user = context.currentUser!;
    final moodSummary = user.moodSummary as MoodSummaryModel;
    final previousSelectMood = widget.entry?.selectedMood;
    final isHappyMood = _selectedMood == 'Happy';
    final isNeutralMood = _selectedMood == 'Neutral';
    final isSadMood = _selectedMood == 'Sad';
    final isAngryMood = _selectedMood == 'Angry';

    if (widget.entry == null) {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.moodSummary,
          userData: moodSummary.copyWith(
            happy: isHappyMood ? moodSummary.happy + 1 : null,
            neutral: isNeutralMood ? moodSummary.neutral + 1 : null,
            sad: isSadMood ? moodSummary.sad + 1 : null,
            angry: isAngryMood ? moodSummary.angry + 1 : null,
          ),
        ),
      );
    }
    if (previousSelectMood == 'Happy') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.moodSummary,
          userData: moodSummary.copyWith(
            happy: moodSummary.happy > 0 ? moodSummary.happy - 1 : 0,
            neutral: isNeutralMood ? moodSummary.neutral + 1 : null,
            sad: isSadMood ? moodSummary.sad + 1 : null,
            angry: isAngryMood ? moodSummary.angry + 1 : null,
          ),
        ),
      );
    }

    if (previousSelectMood == 'Neutral') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.moodSummary,
          userData: moodSummary.copyWith(
            neutral: moodSummary.neutral > 0 ? moodSummary.neutral - 1 : 0,
            happy: isHappyMood ? moodSummary.happy + 1 : null,
            sad: isSadMood ? moodSummary.sad + 1 : null,
            angry: isAngryMood ? moodSummary.angry + 1 : null,
          ),
        ),
      );
    }

    if (previousSelectMood == 'Sad') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.moodSummary,
          userData: moodSummary.copyWith(
            sad: moodSummary.sad > 0 ? moodSummary.sad - 1 : 0,
            happy: isHappyMood ? moodSummary.happy + 1 : null,
            neutral: isNeutralMood ? moodSummary.neutral + 1 : null,
            angry: isAngryMood ? moodSummary.angry + 1 : null,
          ),
        ),
      );
    }

    if (previousSelectMood == 'Angry') {
      bloc.add(
        UpdateUserEvent(
          action: UpdateUserAction.sentimentSummary,
          userData: moodSummary.copyWith(
            angry: moodSummary.angry > 0 ? moodSummary.angry - 1 : 0,
            happy: isHappyMood ? moodSummary.happy + 1 : null,
            sad: isSadMood ? moodSummary.sad + 1 : null,
            neutral: isNeutralMood ? moodSummary.neutral + 1 : null,
          ),
        ),
      );
    }
  }
}
