import 'package:flutter/widgets.dart';
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

  void createAccount() {
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
  }
}
