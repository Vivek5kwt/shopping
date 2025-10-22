class AddressParser {
  static Map<String, String> parseAddress(String address) {
    // Handle empty or null address
    if (address.isEmpty) {
      return {
        'name': '',
        'phoneNumber': '',
        'street': '',
        'postalCode': '',
        'city': '',
        'state': '',
        'country': '',
      };
    }

    try {
      // Split by comma and trim whitespace
      final parts = address.split(',').map((e) => e.trim()).toList();

      // Ensure we have exactly 7 parts
      if (parts.length != 7) {
        return {
          'name': '',
          'phoneNumber': '',
          'street': '',
          'postalCode': '',
          'city': '',
          'state': '',
          'country': '',
        };
      }

      return {
        'name': parts[0], // Imran Khan
        'phoneNumber': parts[1], // +92 3345339242
        'street': parts[2], // F8
        'postalCode': parts[3], // 3450E
        'city': parts[4], // Islamabad
        'state': parts[5], // Punjab
        'country': parts[6], // Pakistan
      };
    } catch (e) {
      // Return empty map on any parsing error
      return {
        'name': '',
        'phoneNumber': '',
        'street': '',
        'postalCode': '',
        'city': '',
        'state': '',
        'country': '',
      };
    }
  }
}
