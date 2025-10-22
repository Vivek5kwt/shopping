class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;
  final String? token;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.token,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['user'] ?? json['data'],
      token: json['token'],
    );
  }
}
