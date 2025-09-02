import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_fields/form_fields.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yandex_eats_clone/app/app.dart';

class UserUpdateEmailForm extends StatefulWidget {
  const UserUpdateEmailForm({super.key});

  @override
  State<UserUpdateEmailForm> createState() => _UserUpdateEmailFormState();
}

class _UserUpdateEmailFormState extends State<UserUpdateEmailForm> {
  final formKey = GlobalKey<ShadFormState>();
  late ValueNotifier<bool> _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = ValueNotifier(true);
  }

  @override
  void dispose() {
    _obscure.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      appBar: AppBar(
        title: const Text('Update email'),
        titleTextStyle: context.headlineSmall,
        centerTitle: false,
      ),
      body: AppConstrainedScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            children: [
              Expanded(
                child: ShadForm(
                  key: formKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 462),
                    child: Column(
                      children: [
                        ShadInputFormField(
                          id: 'email',
                          label: const Text('Email'),
                          placeholder: const Text('abc@gmail.com'),
                          prefix: const Padding(
                            padding: EdgeInsets.all(AppSpacing.sm),
                            child: ShadImage.square(
                              size: AppSpacing.lg,
                              LucideIcons.mail,
                            ),
                          ),
                          validator: (value) {
                            final email = Email.dirty(value);
                            return email.errorMessage;
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: _obscure,
                          child: const Padding(
                            padding: EdgeInsets.all(AppSpacing.sm),
                            child: ShadImage.square(
                              size: AppSpacing.lg,
                              LucideIcons.lock,
                            ),
                          ),
                          builder: (context, obscure, prefix) {
                            return ShadInputFormField(
                              id: 'password',
                              label: const Text('Password'),
                              placeholder: const Text('12345678'),
                              prefix: prefix,
                              obscureText: obscure,
                              suffix: ShadButton.secondary(
                                width: AppSpacing.xlg + AppSpacing.sm,
                                height: AppSpacing.xlg + AppSpacing.sm,
                                padding: EdgeInsets.zero,
                                decoration: const ShadDecoration(
                                  secondaryBorder: ShadBorder.none,
                                  secondaryFocusedBorder: ShadBorder.none,
                                ),
                                icon: ShadImage.square(
                                  obscure
                                      ? LucideIcons.eyeOff
                                      : LucideIcons.eye,
                                  size: AppSpacing.lg,
                                ),
                                onPressed: () =>
                                    _obscure.value = !_obscure.value,
                              ),
                              validator: (value) {
                                final password = Password.dirty(value);
                                return password.errorMessage;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ShadButton(
                width: double.infinity,
                child: const Text('Update email'),
                onPressed: () async {
                  if (!(formKey.currentState?.validate() ?? false)) {
                    return;
                  }
                  final email = formKey.currentState?.value['email'] as String;
                  final password =
                      formKey.currentState?.value['password'] as String;
                  context.read<AppBloc>().add(
                    AppUpdateAccountEmailRequested(
                      email: email,
                      password: password,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: 10.seconds,
                      content: const Text(
                        'Verification email sent. Please check your new email'
                        ' and verify.',
                      ),
                    ),
                  );

                  final mailInboxUrl = Uri.parse(
                    'https://mail.google.com/mail/u/0/#inbox',
                  );
                  void logout() {
                    context.read<AppBloc>().add(const AppLogoutRequested());
                  }

                  await launchUrl(mailInboxUrl);
                  logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
