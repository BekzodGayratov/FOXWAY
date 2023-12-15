import 'package:accountant/helpers/show_message.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState.initial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginState.loading());
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(const LoginState.success());
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        emit(const LoginState.error("Foydalanuvchi topilmadi"));
      } else if (e.code == "wrong-password") {
        emit(const LoginState.error("Parolni xato kiritdingiz"));
      } else {
        emit(const LoginState.error("Noma'lum xato yuz berdi"));
      }
    }
  }
}
