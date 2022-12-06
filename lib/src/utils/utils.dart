bool strNotEmpty(String? str) {
  return !strEmpty(str);
}

bool strEmpty(String? str) {
  return str == null || str.isEmpty;
}