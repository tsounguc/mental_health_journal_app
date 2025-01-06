import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_journal_app/core/common/views/long_button.dart';
import 'package:mental_health_journal_app/core/extensions/context_extension.dart';
import 'package:mental_health_journal_app/core/utils/core_utils.dart';
import 'package:mental_health_journal_app/features/auth/data/models/user_model.dart';
import 'package:mental_health_journal_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:mental_health_journal_app/features/auth/presentation/widgets/sign_up_form.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const id = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void signUp(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    // TODO(FirebaseAuth): FirebaseAuth.instance.currentUser?.reload();
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpEvent(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          // BlocConsumer<AuthBloc, AuthState>(
          //   listener: (context, state) {
          //     if (state is AuthError) {
          //       CoreUtils.showSnackBar(context, state.message);
          //     } else if (state is SignedUp) {
          //       context.read<AuthBloc>().add(
          //             SignInEvent(
          //               email: emailController.text.trim(),
          //               password: passwordController.text.trim(),
          //             ),
          //           );
          //     } else if (state is SignedIn) {
          //       context.userProvider.initUser(state.user as UserModel);
          //       Navigator.pushReplacementNamed(context, '/');
          //     }
          //   },
          //   builder: (context, state) {
          //     return
          SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 35,
            ).copyWith(top: 15),
            children: [
              const SizedBox(height: 35),
              // TODO(Logo): Create Logo and Add Here
              const SizedBox(height: 50),
              Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: context.theme.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 14,
                  color: context.theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 20),
              SignUpForm(
                formKey: formKey,
                nameController: nameController,
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                onConfirmPasswordFieldSubmitted: (_) => signUp(context),
              ),
              const SizedBox(height: 50),
              // if (state is AuthLoading)
              //   const Center(
              //     child: CircularProgressIndicator(),
              //   ),
              // else
              LongButton(
                onPressed: () => signUp(context),
                label: 'Sign up',
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.theme.textTheme.bodyMedium?.color,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.theme.primaryColor,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // },
      // ),
    );
  }
}
