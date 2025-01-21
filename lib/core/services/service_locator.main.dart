part of 'service_locator.dart';

final serviceLocator = GetIt.instance;

Future<void> setUpServices() async {
  await _initAuth();
  await _initJournal();
}

Future<void> _initJournal() async {
  serviceLocator
    ..registerFactory(
      () => JournalCubit(
        createJournalEntry: serviceLocator(),
        deleteJournalEntry: serviceLocator(),
        updateJournalEntry: serviceLocator(),
        getJournalEntries: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SearchCubit(
        searchJournalEntries: serviceLocator(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => CreateJournalEntry(serviceLocator()))
    ..registerLazySingleton(() => DeleteJournalEntry(serviceLocator()))
    ..registerLazySingleton(() => UpdateJournalEntry(serviceLocator()))
    ..registerLazySingleton(() => GetJournalEntries(serviceLocator()))
    ..registerLazySingleton(() => SearchJournalEntries(serviceLocator()))

    // Repository
    ..registerLazySingleton<JournalRepository>(
      () => JournalRepositoryImpl(serviceLocator()),
    )

    // Data Sources
    ..registerLazySingleton<JournalRemoteDataSource>(
      () => JournalRemoteDataSourceImpl(
        authClient: serviceLocator(),
        firestoreClient: serviceLocator(),
      ),
    );
}

Future<void> _initAuth() async {
  serviceLocator
    // App Logic
    ..registerFactory(
      () => AuthBloc(
        createUserAccount: serviceLocator(),
        signIn: serviceLocator(),
        signOut: serviceLocator(),
        forgotPassword: serviceLocator(),
        deleteAccount: serviceLocator(),
        updateUser: serviceLocator(),
      ),
    )
    // Use cases
    ..registerLazySingleton(() => CreateUserAccount(serviceLocator()))
    ..registerLazySingleton(() => SignIn(serviceLocator()))
    ..registerLazySingleton(() => SignOut(serviceLocator()))
    ..registerLazySingleton(() => ForgotPassword(serviceLocator()))
    ..registerLazySingleton(() => DeleteAccount(serviceLocator()))
    ..registerLazySingleton(() => UpdateUser(serviceLocator()))

    // Repositories
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator()),
    )
    // Data Sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        authClient: serviceLocator(),
        firestoreClient: serviceLocator(),
        storageClient: serviceLocator(),
      ),
    )
    // External dependencies
    ..registerLazySingleton(() => FirebaseAuth.instance)
    ..registerLazySingleton(() => FirebaseFirestore.instance)
    ..registerLazySingleton(() => FirebaseStorage.instance);
}
