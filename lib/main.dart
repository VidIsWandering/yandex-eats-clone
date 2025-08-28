import 'dart:developer';

import 'package:firebase_authentication_client/firebase_authentication_client.dart';
import 'package:token_storage/token_storage.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_eats_clone/app/app.dart';
import 'package:yandex_eats_clone/bootstrap.dart';

void main() async {
  await bootstrap(() async {
    final tokenStorage = InMemoryTokenStorage();
    final firebaseAuthenticationClient = FirebaseAuthenticationClient(
      tokenStorage: tokenStorage,
    );
    final userRepository = UserRepository(
      authenticationClient: firebaseAuthenticationClient,
    );

    log('${(await userRepository.user.first).name}');

    return App(
      userRepository: userRepository,
      user: await userRepository.user.first,
    );
  });
}
