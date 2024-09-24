import 'package:lesson6/view/createaccount_screen.dart';

class CreateAccountController{
  CreateAccountState state;
  CreateAccountController(this.state);

  void showHidePasswords(bool? value){
    if (value != null){
      state.callSetState((){
        state.model.showPasswords = value;
      });
      state.model.showPasswords = value;
    }
  }

  void createAccount(){
    
  }
}