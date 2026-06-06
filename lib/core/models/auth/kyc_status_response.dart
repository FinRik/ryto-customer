class KycResponse {
  final String identityStatus;
  final String licenseStatus;

  KycResponse({
    required this.identityStatus,
    required this.licenseStatus,
  });

  factory KycResponse.fromJson(Map<String, dynamic> json) {
    return KycResponse(
      identityStatus: json['identityStatus'],
      licenseStatus: json['licenseStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'identityStatus': identityStatus,
      'licenseStatus': licenseStatus,
    };
  }
}