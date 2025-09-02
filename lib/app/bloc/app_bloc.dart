// ignore_for_file: avoid_catches_without_on_clauses, document_ignores

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
    on<AppUpdateAccountRequested>(_onAppUpdateAccountRequested);
    on<AppUpdateAccountEmailRequested>(_onAppUpdateAccountEmailRequested);
    on<AppDeleteAccountRequested>(_onAppDeleteAccountRequested);
    on<AppLogoutRequested>(_onAppLogoutRequested);

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

  FutureOr<void> _onAppUpdateAccountRequested(
    AppUpdateAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.updateProfile(username: event.username);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onAppUpdateAccountEmailRequested(
    AppUpdateAccountEmailRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.updateEmail(
        email: event.email,
        password: event.password,
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  FutureOr<void> _onAppDeleteAccountRequested(
    AppDeleteAccountRequested event,
    Emitter<AppState> emit,
  ) async {
    try {
      await _userRepository.deleteAccount();
    } catch (error, stackTrace) {
      await _userRepository.logOut();
      addError(error, stackTrace);
    }
  }

  void _onAppLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_userRepository.logOut());
  }
}
