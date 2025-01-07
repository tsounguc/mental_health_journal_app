import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:mental_health_journal_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:mental_health_journal_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mental_health_journal_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/create_user_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/delete_account.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/forgot_password.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_in.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/sign_out.dart';
import 'package:mental_health_journal_app/features/auth/domain/use_cases/update_user.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

part 'service_locator.main.dart';
