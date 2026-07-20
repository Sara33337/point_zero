import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point_zero/features/auth/domain/entities/user_entity.dart';
import 'package:point_zero/features/auth/domain/useCases/login_useCase.dart';
import 'package:point_zero/features/auth/presentation/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(username, password);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  void loginAsManager(String password) {
  if (password == '1234') {
    emit(const AuthAuthenticated(user: UserEntity(id: 1, username: 'Manager', role: 'manager')));
  } else {
   
    emit(const AuthError(message: 'كلمة المرور غير صحيحة'));
  }
}

  void logout() {
    // Clears the user from the state and sends them back to the login screen
    emit(AuthUnauthenticated());
  }
}