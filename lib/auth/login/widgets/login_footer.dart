import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_eats_clone/auth/cubit/auth_cubit.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        Tappable.faded(
          fadeStrength: FadeStrength.lg,
          child: Text(
            'Sign up',
            style: context.bodyMedium?.copyWith(fontWeight: AppFontWeight.bold),
          ),
          onTap: () => context.read<AuthCubit>().changeAuth(showLogin: false),
        ),
      ],
    );
  }
}
