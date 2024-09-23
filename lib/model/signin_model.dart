class SigninModel{
  String? email;
  String? password;
  bool inProgress = false;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "No Email address is provided";
    }
    else if((value.contains('@') && value.contains('.')) == false){
      return "Email address is not valid";
    }
    else{
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "No password is provided";
    }
    else if(value.length < 6){
      return "Password must be at least 6 characters long";
    }
    else{
      return null;
    }
  }

  void saveEmail(String? value) {
    if (value != null) {
      email = value;
    }
  }

  void savePassword(String? value) {
    if (value != null) {
      password = value;
    }
  }

}