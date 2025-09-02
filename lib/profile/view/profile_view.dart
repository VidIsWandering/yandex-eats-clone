import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_eats_clone/app/bloc/app_bloc.dart';
import 'package:yandex_eats_clone/profile/profile.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    final user = context.select(
      (AppBloc bloc) => bloc.state.user,
    );

    return AppScaffold(
      resizeToAvoidBottomInset: true,
      releaseFocus: true,
      appBar: AppBar(
        title: const Text('Profile'),
        titleTextStyle: context.headlineSmall,
        centerTitle: false,
        actions: [
          AppIcon.button(
            icon: LucideIcons.check,
            onTap: () {
              if (!(formKey.currentState?.validate() ?? false)) return;
              final username =
                  formKey.currentState?.value['username'] as String;
              if (user.name != username) {
                context.read<AppBloc>().add(
                  AppUpdateAccountRequested(username),
                );
              }
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Successfully updated account!'),
                  ),
                );
            },
          ),
          AppIcon.button(
            icon: LucideIcons.alignJustify,
            onTap: () {
              showMenu(
                context: context,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                position: RelativeRect.fromDirectional(
                  textDirection: TextDirection.ltr,
                  start: AppSpacing.md,
                  top: AppSpacing.md,
                  end: 0,
                  bottom: 0,
                ),
                items: [
                  PopupMenuItem<void>(
                    onTap: () => context.confirmAction(
                      fn: () {
                        context.read<AppBloc>().add(const AppLogoutRequested());
                      },
                      title: 'Logout',
                      content: 'Are you sure to logout from your account?',
                      yesText: 'Yes, logout',
                      noText: 'No, cancel',
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          LucideIcons.logOut,
                          size: AppSpacing.xs,
                        ),
                        const SizedBox(
                          width: AppSpacing.sm,
                        ),
                        Text(
                          'Log out',
                          style: context.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: AppConstrainedScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Column(
            children: [
              UserCredentialsForm(
                formKey: formKey,
              ),
              const SizedBox(
                height: AppSpacing.md,
              ),
              ...ListTile.divideTiles(
                context: context,
                tiles: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => context.confirmAction(
                      fn: () => context.read<AppBloc>().add(
                        const AppDeleteAccountRequested(),
                      ),
                      title: 'Delete account',
                      content:
                          'Are you sure to permanetly delete your account? '
                          'All your data will be deleted.',
                      noText: 'No, keep it',
                      yesText: 'Yes, delete',
                    ),
                    leading: const Icon(LucideIcons.trash),
                    title: const Text('Delete account'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
