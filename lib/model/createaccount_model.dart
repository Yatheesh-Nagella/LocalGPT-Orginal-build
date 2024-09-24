class CreateAccountModel{
  String? email;
  String? password;
  String? passwordConfirm;
  bool showPasswords = false;
  bool inProgress = false;

  String? validateEmail(String? value){
    if(value == null || value.isEmpty) return 'Please enter an email address';
      String email = value.trim();
    if(!(email.contains('@') && email.contains('.'))){
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value){
    if(value == null || value.isEmpty) return 'Please enter a password';
    String password = value.trim();
    if(password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void saveEmail(String? value){
    email = value?.trim();
  }

  void savePassword(String? value){
    password = value?.trim();
  }

  void savePasswordConfirm(String? value){
    passwordConfirm = value?.trim();
  }
}