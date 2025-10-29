// Input validation utilities
class Validators {
  Validators._();

  // Validate non-empty string
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  // Validate number
  static String? validateNumber(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  // Validate positive number
  static String? validatePositiveNumber(String? value, {String? fieldName}) {
    final numberError = validateNumber(value, fieldName: fieldName);
    if (numberError != null) return numberError;

    final number = double.parse(value!);
    if (number <= 0) {
      return '${fieldName ?? 'Value'} must be greater than 0';
    }
    return null;
  }

  // Validate volume (integer)
  static String? validateVolume(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Volume is required';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter a valid volume';
    }
    if (int.parse(value) <= 0) {
      return 'Volume must be greater than 0';
    }
    return null;
  }

  // Validate price
  static String? validatePrice(String? value) {
    return validatePositiveNumber(value, fieldName: 'Price');
  }

  // Validate PIN
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length < 4) {
      return 'PIN must be at least 4 digits';
    }
    return null;
  }

  // Validate stock symbol
  static String? validateStockSymbol(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a stock';
    }
    return null;
  }
}
