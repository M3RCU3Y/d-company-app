import 'package:flutter/material.dart';

import '../../../app/app_scope.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/presentation/widgets/brand_wordmark.dart';
import '../../../core/presentation/widgets/primary_cta_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController(text: 'ari@dtable.app');
  final passwordController = TextEditingController(text: 'password123');
  var isSignUp = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppScope.of(context).authController;
    final theme = Theme.of(context);

    return Scaffold(
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
            children: [
              const BrandWordmark(),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSignUp ? 'Create your account' : 'Sign in',
                      style: theme.textTheme.titleLarge?.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isSignUp
                          ? 'Start saving restaurants and managing bookings in one place.'
                          : 'Pick up where your reservations left off.',
                      style: theme.textTheme.bodyLarge,
                    ),
                    if (isSignUp) ...[
                      const SizedBox(height: 18),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    if (controller.errorText != null) ...[
                      const SizedBox(height: 14),
                      Text(
                        controller.errorText!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    PrimaryCtaButton(
                      label: isSignUp ? 'Create account' : 'Sign in',
                      isBusy: controller.isBusy,
                      onPressed: () async {
                        if (isSignUp) {
                          await controller.signUp(
                            name: nameController.text,
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        } else {
                          await controller.signIn(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => setState(() => isSignUp = !isSignUp),
                      child: Text(
                        isSignUp
                            ? 'Already have an account? Sign in'
                            : 'Need an account? Create one',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
