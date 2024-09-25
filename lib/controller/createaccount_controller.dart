// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lesson6/controller/auth_controller.dart';
import 'package:lesson6/view/createaccount_screen.dart';
import 'package:lesson6/view/show_snackbar.dart';

class CreateAccountController {
  CreateAccountState state;
  CreateAccountController(this.state);

  void showHidePasswords(bool? value) {
    if (value != null) {
      state.callSetState(() {
        state.model.showPasswords = value;
      });
      state.model.showPasswords = value;
    }
  }

  Future<void> createAccount() async {
    FormState? currentState = state.formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;

    currentState.save();
    if (state.model.password != state.model.passwordConfirm) {
      showSnackbar(
        context: state.context,
        message: "Two passwords do not match",
        seconds: 20,
      );
      return;
    }

    state.callSetState(() => state.model.inProgress = true);

    try {
      await firebaseCreateAccount(
        email: state.model.email!,
        password: state.model.password!,
      );
      state.model.email = '';
      state.model.password = '';
      state.model.passwordConfirm = '';
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: 'Account created. Press BACK to go home',
          seconds: 20,
        );
      }
    } on FirebaseAuthException catch (e) {
      print('=======> create account error: ${e.code} ${e.message}');
      if (state.mounted) {
        showSnackbar(
          context: state.context,
          message: '${e.code} ${e.message}',
          seconds: 20,
        );
      }
      showSnackbar(
        context: state.context,
        message: '${e.code} ${e.message}',
        seconds: 20,
      );
    } catch (e) {
      print('=======> create account error: $e');
      showSnackbar(
        context: state.context,
        message: 'Create account error: $e',
        seconds: 20,
      );
    } finally {
      state.callSetState(() => state.model.inProgress = false);
    }
  }
}
