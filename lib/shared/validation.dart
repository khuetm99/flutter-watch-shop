class Validation {
  static isEmailValid(String email) {
    final regexEmail = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return regexEmail.hasMatch(email);
  }

  static isPhoneValid(String phone) {
    final regexPhone = RegExp(r'^[0-9]+$');
    return regexPhone.hasMatch(phone);
  }

  static isPassValid(String pass) {
    return pass.length >= 6;
  }

  static isDisplayNameValid(String displayName) {
    return displayName.length > 5;
  }
}
