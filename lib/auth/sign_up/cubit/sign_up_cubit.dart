// ignore_for_file: avoid_catches_without_on_clauses, document_ignores

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';
import 'package:yandex_eats_clone/auth/login/login.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(const SignUpState.initial());

  final UserRepository _userRepository;

  Future<void> onSubmit({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
        emit(state.copyWith(status: SubmissionStatus.inProgress));
      await _userRepository.signUpWithPassword(
        email: email,
        password: password,
        username: username,
      );
        emit(state.copyWith(status: SubmissionStatus.success));
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      if (!isClosed) {
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
    }
  }
}
