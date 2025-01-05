import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/app/providers/user_provider.dart';
import 'package:mental_health_journal_app/core/common/views/page_under_construction.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/services/service_locator.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/sign_in_screen.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:mental_health_journal_app/features/dashboard/presentation/dashboard.dart';
import 'package:provider/provider.dart';

part 'router.main.dart';
