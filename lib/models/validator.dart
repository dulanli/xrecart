import 'package:email_validator/email_validator.dart';

class Validator {

  String? validateEmail(String? value) {
    bool isEmail(String email) => EmailValidator.validate(email);
    if (!isEmail(value!.trim())) {
      return 'This is not a valid email';
    } else {
      return null;
    }
  }

  String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return 'This field cannot be empty';
    } else if (value.length < 4) {
      return 'This field must contains 4 characters';
    } else {
      return null;
    }
  }

  String? descriptionValidator(String? value) {
    if (value!.isEmpty) {
      return 'This field cannot be empty';
    } else {
      return null;
    }
  }
}
