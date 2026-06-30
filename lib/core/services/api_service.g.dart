// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://api.getryto.com';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  Future<BaseModel<dynamic>> _login(String phone) async {
    final _extra = <String, dynamic>{'isPublic': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phone};
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/customer/login/phone',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> login(String phone) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _login(phone));
  }

  Future<BaseModel<AuthResponse>> _register(String phone) async {
    final _extra = <String, dynamic>{'isPublic': true};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phone};
    final _options = _setStreamType<BaseModel<AuthResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/customer/signup/phone',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<AuthResponse> _value;
    try {
      _value = BaseModel<AuthResponse>.fromJson(
        _result.data!,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<AuthResponse>> register(String phone) {
    return ErrorAdapter<BaseModel<AuthResponse>>().adapt(
      () => _register(phone),
    );
  }

  Future<BaseModel<AuthResponse>> _verifyLogin(
    String phone,
    String code,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'phone': phone, 'code': code};
    final _options = _setStreamType<BaseModel<AuthResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/customer/verify-login',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<AuthResponse> _value;
    try {
      _value = BaseModel<AuthResponse>.fromJson(
        _result.data!,
        (json) => AuthResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<AuthResponse>> verifyLogin(String phone, String code) {
    return ErrorAdapter<BaseModel<AuthResponse>>().adapt(
      () => _verifyLogin(phone, code),
    );
  }

  Future<BaseModel<UserEntity>> _verifyOtp(String code) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code};
    final _options = _setStreamType<BaseModel<UserEntity>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/customer/verify/phone',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<UserEntity> _value;
    try {
      _value = BaseModel<UserEntity>.fromJson(
        _result.data!,
        (json) => UserEntity.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<UserEntity>> verifyOtp(String code) {
    return ErrorAdapter<BaseModel<UserEntity>>().adapt(() => _verifyOtp(code));
  }

  Future<BaseModel<dynamic>> _resendOtp() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/customer/resend-phone-verification',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> resendOtp() {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(() => _resendOtp());
  }

  Future<BaseModel<UserEntity>> _fetchProfile() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<UserEntity>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/auth/customer/user',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<UserEntity> _value;
    try {
      _value = BaseModel<UserEntity>.fromJson(
        _result.data!,
        (json) => UserEntity.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<UserEntity>> fetchProfile() {
    return ErrorAdapter<BaseModel<UserEntity>>().adapt(() => _fetchProfile());
  }

  Future<BaseModel<UserEntity>> _updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required File image,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('firstName', firstName));
    _data.fields.add(MapEntry('lastName', lastName));
    _data.fields.add(MapEntry('email', email));
    _data.files.add(
      MapEntry(
        'profilePicture',
        MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split(Platform.pathSeparator).last,
        ),
      ),
    );
    final _options = _setStreamType<BaseModel<UserEntity>>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            '/auth/customer/complete-profile',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<UserEntity> _value;
    try {
      _value = BaseModel<UserEntity>.fromJson(
        _result.data!,
        (json) => UserEntity.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required File image,
  }) {
    return ErrorAdapter<BaseModel<UserEntity>>().adapt(
      () => _updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
        image: image,
      ),
    );
  }

  Future<BaseModel<RideResponse>> _fetchUserTrips(String? status) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'status': status};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<RideResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/customer/trips',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<RideResponse> _value;
    try {
      _value = BaseModel<RideResponse>.fromJson(
        _result.data!,
        (json) => RideResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<RideResponse>> fetchUserTrips(String? status) {
    return ErrorAdapter<BaseModel<RideResponse>>().adapt(
      () => _fetchUserTrips(status),
    );
  }

  Future<BaseModel<RideSummary>> _fetchTripSummary(String id) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<RideSummary>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/customer/trips/${id}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<RideSummary> _value;
    try {
      _value = BaseModel<RideSummary>.fromJson(
        _result.data!,
        (json) => RideSummary.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<RideSummary>> fetchTripSummary(String id) {
    return ErrorAdapter<BaseModel<RideSummary>>().adapt(
      () => _fetchTripSummary(id),
    );
  }

  Future<BaseModel<RideResponse>> _fetchAvailableTrips({
    int? passengerSeats,
    String? departureDate,
    String? destinationCity,
    String? originCity,
    String? currency,
    String? country,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'passengerSeats': passengerSeats,
      r'departureDate': departureDate,
      r'destinationCity': destinationCity,
      r'originCity': originCity,
      r'currency': currency,
      r'country': country,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<RideResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/customer/trips/filter',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<RideResponse> _value;
    try {
      _value = BaseModel<RideResponse>.fromJson(
        _result.data!,
        (json) => RideResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<RideResponse>> fetchAvailableTrips({
    int? passengerSeats,
    String? departureDate,
    String? destinationCity,
    String? originCity,
    String? currency,
    String? country,
  }) {
    return ErrorAdapter<BaseModel<RideResponse>>().adapt(
      () => _fetchAvailableTrips(
        passengerSeats: passengerSeats,
        departureDate: departureDate,
        destinationCity: destinationCity,
        originCity: originCity,
        currency: currency,
        country: country,
      ),
    );
  }

  Future<BaseModel<List<PopularRoute>>> _fetchPopularRoutes(
    String currency,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'currency': currency};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<BaseModel<List<PopularRoute>>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/customer/trips/popular-routes',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<List<PopularRoute>> _value;
    try {
      _value = BaseModel<List<PopularRoute>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                  .map<PopularRoute>(
                    (i) => PopularRoute.fromJson(i as Map<String, dynamic>),
                  )
                  .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<List<PopularRoute>>> fetchPopularRoutes(String currency) {
    return ErrorAdapter<BaseModel<List<PopularRoute>>>().adapt(
      () => _fetchPopularRoutes(currency),
    );
  }

  Future<BaseModel<BookingCost>> _fetchBookingCost(
    BookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<BookingCost>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/booking/summary',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<BookingCost> _value;
    try {
      _value = BaseModel<BookingCost>.fromJson(
        _result.data!,
        (json) => BookingCost.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<BookingCost>> fetchBookingCost(BookingRequest request) {
    return ErrorAdapter<BaseModel<BookingCost>>().adapt(
      () => _fetchBookingCost(request),
    );
  }

  Future<BaseModel<BookingResponse>> _scheduleTrip(
    BookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<BookingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/booking',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<BookingResponse> _value;
    try {
      _value = BaseModel<BookingResponse>.fromJson(
        _result.data!,
        (json) => BookingResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<BookingResponse>> scheduleTrip(BookingRequest request) {
    return ErrorAdapter<BaseModel<BookingResponse>>().adapt(
      () => _scheduleTrip(request),
    );
  }

  Future<BaseModel<BookingResponse>> _bookPackage(
    BookingRequest request,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _options = _setStreamType<BaseModel<BookingResponse>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/booking',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<BookingResponse> _value;
    try {
      _value = BaseModel<BookingResponse>.fromJson(
        _result.data!,
        (json) => BookingResponse.fromJson(json as Map<String, dynamic>),
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<BookingResponse>> bookPackage(BookingRequest request) {
    return ErrorAdapter<BaseModel<BookingResponse>>().adapt(
      () => _bookPackage(request),
    );
  }

  Future<BaseModel<dynamic>> _verifyPayment(
    int transactionId,
    int bookingId,
    String reference,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'transactionId': transactionId,
      'bookingId': bookingId,
      'reference': reference,
    };
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/booking/verify-payment',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> verifyPayment(
    int transactionId,
    int bookingId,
    String reference,
  ) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _verifyPayment(transactionId, bookingId, reference),
    );
  }

  Future<BaseModel<dynamic>> _cancelTrip(String reason, int bookingId) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'reason': reason, 'bookingId': bookingId};
    final _options = _setStreamType<BaseModel<dynamic>>(
      Options(method: 'PATCH', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/booking/cancel',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseModel<dynamic> _value;
    try {
      _value = BaseModel<dynamic>.fromJson(
        _result.data!,
        (json) => json as dynamic,
      );
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options, response: _result);
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseModel<dynamic>> cancelTrip(String reason, int bookingId) {
    return ErrorAdapter<BaseModel<dynamic>>().adapt(
      () => _cancelTrip(reason, bookingId),
    );
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
