import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/app/providers/tab_navigator.dart';
import 'package:mental_health_journal_app/core/common/views/persistent_view.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_cubit/journal_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/search_cubit/search_cubit.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_home_screen.dart';
import 'package:mental_health_journal_app/features/profile/presentation/views/profile_screen.dart';
import 'package:provider/provider.dart';

class DashBoardController extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => serviceLocator<JournalCubit>(),
              ),
              BlocProvider(
                create: (_) => serviceLocator<SearchCubit>(),
              ),
            ],
            child: const JournalHomeScreen(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const Placeholder(
            child: Center(
              child: Text('Insights View'),
            ),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: BlocProvider(
            create: (_) => serviceLocator<AuthBloc>(),
            child: const ProfileScreen(),
          ),
        ),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}
