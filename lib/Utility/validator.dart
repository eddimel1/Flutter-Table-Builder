class Validator {
  static String? validateMaxNumber(int max, value) {
    if ((value == null || value.isEmpty)) {
      return 'please enter a number';
    } else if (int.parse(value) > max) {
      return 'value cant be more than $max';
    } else {
      return null;
    }
  }

  static String? validateMaxStringLength(int max, value) {
    if ((value == null || value.isEmpty)) {
      return 'this field cant be empty ';
    } else if (value.toString().length > max) {
      return 'max length is $max';
    } else {
      return null;
    }
  }

  static String trimNonNumberCharacters(String inputString) {
    RegExp regExp = RegExp(r'[^0-9]');
    String cleanedString = inputString.replaceAll(regExp, '');
    return cleanedString;
  }
}
