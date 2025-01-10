import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/views/long_button.dart';
import 'package:mental_health_journal_app/core/common/widgets/logo_widget.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/resources/colours.dart';
import 'package:mental_health_journal_app/core/resources/strings.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/forgot_password_screen.dart';
import 'package:mental_health_journal_app/features/auth/presentation/views/sign_up_screen.dart';
import 'package:mental_health_journal_app/features/auth/presentation/widgets/sign_in_form.dart';
import 'package:mental_health_journal_app/features/journal/presentation/dashboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const id = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    FirebaseAuth.instance.currentUser?.reload();
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.backgroundColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.userProvider.initUser(state.user as UserModel);
            Navigator.pushNamed(context, Dashboard.id);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  LogoWidget(
                    size: 75,
                    color: context.theme.primaryColor,
                  ),
                  const SizedBox(height: 75),
                  Text(
                    Strings.loginText,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Strings.loginSubtext,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SignInForm(
                    emailController: emailController,
                    passwordController: passwordController,
                    onPasswordFieldSubmitted: (_) => signIn(context),
                    formKey: formKey,
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          ForgotPasswordScreen.id,
                        );
                      },
                      child: Text(
                        Strings.forgotPasswordTextButtonText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  if (state is AuthLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  else
                    LongButton(
                      onPressed: () => signIn(context),
                      label: Strings.loginButtonText,
                    ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        SignUpScreen.id,
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: Strings.dontHaveAccountText,
                        style: TextStyle(
                          fontSize: 14,
                          color: context.theme.textTheme.bodyMedium?.color,
                        ),
                        children: [
                          TextSpan(
                            text: Strings.registerTextButtonText,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.theme.primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: context.theme.primaryColor,
                              decorationThickness: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
