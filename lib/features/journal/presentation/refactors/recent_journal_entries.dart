import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_journal_app/core/common/widgets/error_display.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/extensions/string_extensions.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_entry_detail_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/entry_card.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/no_entries_widget.dart';

class RecentJournalEntries extends StatelessWidget {
  const RecentJournalEntries({
    required this.scrollController,
    super.key,
  });
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ).copyWith(top: 8, left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocConsumer<JournalCubit, JournalState>(
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
                        shrinkWrap: true,
                        controller: scrollController,
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

                          return EntryCard(
                            entry: entry,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                JournalEntryDetailScreen.id,
                                arguments: entry,
                              );
                            },
                          );

                          // return Card(
                          //   margin: const EdgeInsets.symmetric(vertical: 6),
                          //   // surfaceTintColor: Colours.secondaryColor,
                          //   color: Colors.white,
                          //   child: ListTile(
                          //     contentPadding: const EdgeInsets.symmetric(
                          //       vertical: 8,
                          //       horizontal: 15,
                          //     ),
                          //     leading: Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           '${entry.dateCreated.day}',
                          //           style: const TextStyle(
                          //             fontSize: 24,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //         Text(
                          //           DateFormat('MMM').format(
                          //             entry.dateCreated,
                          //           ),
                          //           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                          //         ),
                          //       ],
                          //     ),
                          //     title: Padding(
                          //       padding: const EdgeInsets.symmetric(
                          //         vertical: 5,
                          //       ).copyWith(top: 0),
                          //       child: Text(
                          //         entry.title?.capitalizeFirstLetter() ?? 'Untitled',
                          //         style: const TextStyle(
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //       ),
                          //     ),
                          //     subtitle: Text(
                          //       content,
                          //       maxLines: 1,
                          //       overflow: TextOverflow.ellipsis,
                          //       style: const TextStyle(color: Colors.grey),
                          //     ),
                          //     trailing: Text(
                          //       CoreUtils.getEmoji(entry.selectedMood),
                          //       style: const TextStyle(fontSize: 25),
                          //     ),
                          //     // trailing: Icon(
                          //     //   Icons.circle,
                          //     //   color: CoreUtils.getMoodColor(
                          //     //     entry.selectedMood.capitalizeFirstLetter(),
                          //     //   ),
                          //     // ),
                          //     onTap: () {
                          //       Navigator.pushNamed(
                          //         context,
                          //         JournalEntryDetailScreen.id,
                          //         arguments: entry,
                          //       );
                          //     },
                          //   ),
                          // );
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
        ],
      ),
    );
  }
}
