bool isValidPhone(String string) {
  if (string == null || string.isEmpty) {
    return false;
  }
  final number = int.tryParse(string);
  if (number == null) {
    return false;
  }
  if (string.length != 10) {
    return false;
  }
  return true;
}
