class Validators {
  static String? fullName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Please enter your full name';
    if (!RegExp(r'^[A-Z][a-zA-Z]*(\s+[A-Z][a-zA-Z]*)*$').hasMatch(name)) {
      return 'Each name must start with a capital letter';
    }
    return null;
  }

  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value) {
    if ((value ?? '').length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value != password) return 'Passwords do not match';
    return null;
  }
}
