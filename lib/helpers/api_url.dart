class ApiUrl {
  static const String baseUrl = 'http://10.0.2.2/toko_api/public/index.php';

  // Auth Endpoints
  static const String registrasi = '$baseUrl/registrasi'; // Register user
  static const String login = '$baseUrl/login'; // Login user

  // Produk Endpoints
  static const String listProduk = '$baseUrl/produk'; // Get all products
  static const String createProduk = '$baseUrl/produk'; // Create new product

  static String updateProduk(int id) {
    return '$baseUrl/produk/$id'; // Update a specific product
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id'; // Get details of a specific product
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id'; // Delete a specific product
  }
}
