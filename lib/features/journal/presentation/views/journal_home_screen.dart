import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/widgets/error_display.dart';
import 'package:mental_health_journal_app/core/common/widgets/loading_widget.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_bloc/journal_bloc.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/journal_form_field.dart';
import 'package:mental_health_journal_app/features/journal/presentation/widgets/no_entries_widget.dart';

class JournalHomeScreen extends StatelessWidget {
  const JournalHomeScreen({super.key});

  static const id = '/journal-home';

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<JournalBloc, JournalState>(
            listener: (context, state) {
              if (state is JournalInitial) {
                print('state is JournalInitial');
                BlocProvider.of<JournalBloc>(context).add(
                  FetchEntriesEvent(
                    userId: context.currentUser!.uid,
                    startAfterId: '',
                    paginationSize: 10,
                  ),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              print('AuthBloc state: $state'); // Add this to confirm the state change.
              if (state is SignedIn || state is AuthInitial) {
                print('Dispatching FetchEntriesEvent with userId: ${context.currentUser?.uid}'); // Debugging
                BlocProvider.of<JournalBloc>(context).add(
                  FetchEntriesEvent(
                    userId: context.currentUser!.uid,
                    startAfterId: '',
                    paginationSize: 10,
                  ),
                );
              }
            },
          )
        ],
        child: BlocBuilder<JournalBloc, JournalState>(
          builder: (context, state) {
            if (state is JournalLoading || state is JournalInitial) {
              return const LoadingWidget();
            } else if (state is JournalError) {
              return ErrorDisplay(errorMessage: state.message);
            } else {
              final journalEntries = (state as EntriesFetched).entries;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 25,
                ),
                child: Column(
                  children: [
                    JournalFormField(
                      hintText: 'Search journal entries',
                      prefixIcon: const Icon(Icons.search),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    const SizedBox(height: 16),
                    // Journal Entries List
                    Expanded(
                      child: journalEntries.isEmpty
                          ? const NoEntriesWidget()
                          : ListView.builder(
                              itemCount: journalEntries.length,
                              // itemCount: 15,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.circle,
                                      color: index % 3 == 0
                                          ? Colours.positiveMoodColor
                                          : index % 3 == 1
                                              ? Colours.negativeMoodColor
                                              : Colours.neutralMoodColor,
                                    ),
                                    title: Text('Entry Title ${index + 1}'),
                                    subtitle: Text(
                                      'Preview of Journal entry ${index + 1}...',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Text('Mar ${10 + index}, 2025'),
                                    onTap: () {},
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Journal Entry Screen
          BlocProvider.of<JournalBloc>(context).add(
            FetchEntriesEvent(
              userId: context.currentUser!.uid,
              startAfterId: '',
              paginationSize: 10,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}
