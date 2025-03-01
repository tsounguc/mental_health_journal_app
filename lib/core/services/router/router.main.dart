part of 'router.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return _pageBuilder(
        (context) {
          serviceLocator<FirebaseAuth>().currentUser?.reload();
          if (serviceLocator<FirebaseAuth>().currentUser != null) {
            final user = serviceLocator<FirebaseAuth>().currentUser!;
            final localUser = UserModel.empty().copyWith(
              uid: user.uid,
              name: user.displayName,
              email: user.email,
              dateCreated: DateTime.now(),
              isVerified: false,
            );

            context.userProvider.initUser(localUser);
            return const Dashboard();
          }
          return BlocProvider(
            create: (_) => serviceLocator<AuthBloc>(),
            child: const SignInScreen(),
          );
        },
        settings: settings,
      );

    case SignInScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const SignInScreen(),
        ),
        settings: settings,
      );
    case SignUpScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const SignUpScreen(),
        ),
        settings: settings,
      );
    case ForgotPasswordScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const ForgotPasswordScreen(),
        ),
        settings: settings,
      );

    case EditProfileScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const EditProfileScreen(),
        ),
        settings: settings,
      );

    case ProfilePictureScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const ProfilePictureScreen(),
        ),
        settings: settings,
      );

    case ChangePasswordScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
          child: const ChangePasswordScreen(),
        ),
        settings: settings,
      );
    case JournalEditorScreen.id:
      final args = settings.arguments as JournalEntry?;
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator<JournalCubit>(),
            ),
            BlocProvider(
              create: (_) => serviceLocator<AuthBloc>(),
            ),
          ],
          child: JournalEditorScreen(
            entry: args,
          ),
        ),
        settings: settings,
      );

    case JournalEntryDetailScreen.id:
      final args = settings.arguments! as JournalEntry;
      return _pageBuilder(
        (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => serviceLocator<JournalCubit>(),
            ),
            BlocProvider(
              create: (context) => serviceLocator<AuthBloc>(),
            ),
          ],
          child: JournalEntryDetailScreen(entry: args),
        ),
        settings: settings,
      );

    case NotificationSettingsScreen.id:
      return _pageBuilder(
        (_) => BlocProvider(
          create: (_) => serviceLocator<NotificationsCubit>(),
          child: const NotificationSettingsScreen(),
        ),
        settings: settings,
      );

    default:
      return _pageBuilder(
        (_) => const PageUnderConstruction(),
        settings: settings,
      );
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext context) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: animation,
      child: child,
    ),
    pageBuilder: (context, _, __) => page(context),
  );
}
