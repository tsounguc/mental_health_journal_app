import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/common/widgets/error_display.dart';
import 'package:mental_health_journal_app/core/common/widgets/i_field.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/search_cubit/search_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_editor_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_entry_detail_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_search_delegate.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/no_entries_widget.dart';

class JournalHomeScreen extends StatefulWidget {
  const JournalHomeScreen({super.key});

  static const id = '/journal-home';

  @override
  State<JournalHomeScreen> createState() => _JournalHomeScreenState();
}

class _JournalHomeScreenState extends State<JournalHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  void getEntries() {
    context.read<JournalCubit>().getEntries(
          userId: context.currentUser?.uid ?? '',
        );
  }

  void _onScroll() {
    final scrollTrigger = _scrollController.position.maxScrollExtent * 0.8;
    if (_scrollController.position.pixels >= scrollTrigger) {
      final cubit = context.read<JournalCubit>();
      if (cubit.state is EntriesFetched) {
        cubit.getEntries(
          userId: context.currentUser!.uid,
          loadMore: true,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    getEntries();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          children: [
            IField(
              controller: TextEditingController(),
              hintText: Strings.searchHintText,
              readOnly: true,
              fillColor: context.theme.scaffoldBackgroundColor,
              focusColor: Colours.softGreyColor,
              prefixIcon: const Icon(Icons.search),
              borderRadius: BorderRadius.circular(16),
              onTap: () async {
                await showSearch(
                  context: context,
                  delegate: JournalSearchDelegate(
                    context.read<SearchCubit>(),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<JournalCubit, JournalState>(
                listener: (context, state) {
                  // print(state);
                  if (state is JournalError) {
                    CoreUtils.showSnackBar(context, state.message);
                  }
                },
                builder: (context, state) {
                  if (state is JournalLoading) {
                    return const LoadingWidget();
                  } else if (state is EntriesFetched) {
                    final journalEntries = state.entries;
                    return journalEntries.isEmpty
                        ? const NoEntriesWidget()
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: journalEntries.length + (state.hasReachedEnd ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index >= journalEntries.length) {
                                return const Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Loading more...',
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final entry = state.entries[index];
                              final date = DateFormat('MMM d, yyyy').format(
                                entry.dateCreated,
                              );

                              Document? document;
                              try {
                                final deltaJson = jsonDecode(entry.content);

                                document = Document.fromJson(deltaJson as List);
                              } on Exception catch (e) {
                                debugPrint(e.toString());
                                document = Document()..insert(0, entry.content);
                              }

                              final content = document.toPlainText();

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.circle,
                                    color: CoreUtils.getSentimentColor(
                                      entry.sentiment.capitalizeFirstLetter(),
                                    ),
                                  ),
                                  title: Text(
                                    entry.title?.capitalizeFirstLetter() ?? 'Untitled',
                                  ),
                                  subtitle: Text(
                                    content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(date),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      JournalEntryDetailScreen.id,
                                      arguments: entry,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                  } else if (state is JournalError) {
                    return const ErrorDisplay(
                      errorMessage: 'Failed to load entries.',
                    );
                  }
                  return const NoEntriesWidget();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Journal Entry Screen
          Navigator.pushNamed(context, JournalEditorScreen.id);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
