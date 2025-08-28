import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required UserRepository userRepository, required User user})
    : _userRepository = userRepository,
      super(
        user.isAnonymous
            ? const AppState.unauthenticated()
            : AppState.authenticated(user),
      ) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppLogoutRequest>(_onAppLogoutRequest);

    _userSubscription = _userRepository.user.listen(
      _userChanged,
      onError: addError,
    );
  }

  final UserRepository _userRepository;

  StreamSubscription<User>? _userSubscription;

  void _userChanged(User user) => add(AppUserChanged(user));

  void _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    final user = event.user;

    switch (state.status) {
      case AppStatus.authenticated:
      case AppStatus.unauthenticated:
        return emit(
          user.isAnonymous
              ? const AppState.unauthenticated()
              : AppState.authenticated(user),
        );
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  void _onAppLogoutRequest(
    AppLogoutRequest event,
    Emitter<AppState> emit,
  ) {
    unawaited(_userRepository.logOut());
  }
}
