import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/views/page_under_construction.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/sign_in_screen.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/journal_bloc/journal_bloc.dart';
import 'package:mental_health_journal_app/features/dashboard/presentation/views/dashboard.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/journal_home_screen.dart';
import 'package:mental_health_journal_app/features/journal/presentation/views/new_journal_entry_screen.dart';

part 'router.main.dart';
