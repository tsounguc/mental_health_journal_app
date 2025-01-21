import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/presentation/search_cubit/search_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_entry_detail_screen.dart';

class JournalSearchDelegate extends SearchDelegate<List<Widget>?> {
  JournalSearchDelegate(this.searchCubit);

  final SearchCubit searchCubit;

  @override
  String? get searchFieldLabel => Strings.searchHintText;

  @override
  @override
  TextStyle? get searchFieldStyle => const TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );

  // @override
  // ThemeData appBarTheme(BuildContext context) {
  //   return ThemeData(
  //     appBarTheme: context.theme.appBarTheme,
  //     searchBarTheme: context.theme.searchBarTheme,
  //   );
  // }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchCubit.searchEntries(query);

    return BlocBuilder(
      bloc: searchCubit,
      builder: (context, state) {
        if (state is SearchingJournal) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchError) {
          return const Center(child: Text('Failed to fetch entries.'));
        }

        if (state is EntriesSearched && state.entries.isEmpty) {
          return const Center(
              child: Text(
            'No entries found.',
            style: TextStyle(
              color: Colours.softGreyColor,
            ),
          ));
        } else if (state is EntriesSearched && state.entries.isNotEmpty) {
          return ListView.builder(
            itemCount: state.entries.length,
            itemBuilder: (context, index) {
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
        }
        return const Center(
            child: Text(
          'Start searching',
          style: TextStyle(
            color: Colours.softGreyColor,
          ),
        ));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Optionally show suggestions (e.g., recent searches or similar queries)
    if (query.isEmpty) {
      return const Center(
          child: Text(Strings.searchBodyInitialText,
              style: TextStyle(
                color: Colours.softGreyColor,
                fontSize: 16,
              )));
    } else {
      // Trigger the search action in the cubit
      searchCubit.searchEntries(query);

      return BlocBuilder(
        bloc: searchCubit,
        builder: (context, state) {
          if (state is SearchingJournal) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is EntriesSearched) {
            return ListView.builder(
              itemCount: state.entries.length,
              itemBuilder: (context, index) {
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
          } else if (state is SearchError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(child: Text('No suggestions available.'));
          }
        },
      );
    }
  }
}
