import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../app/api_urls.dart';
import '../config/custom_dio_exception.dart';
import '../models/auth/auth_response.dart';
import '../models/booking/booking_request.dart';
import '../models/booking/booking_response.dart';
import '../models/booking/booking_cost.dart';
import '../models/popular_route.dart';
import '../models/ride/ride_response.dart';
import '../models/base.dart';
import '../models/ride/ride_summary.dart';
import '../models/user/user_entity.dart';

part 'api_service.g.dart';

class ErrorAdapter<T> extends CallAdapter<Future<T>, Future<T>> {
  @override
  Future<T> adapt(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      // Transform raw DioException into your Custom version
      throw CustomDioException.fromDioException(e);
    } catch (e) {
      rethrow;
    }
  }
}

@RestApi(baseUrl: ApiUrls.baseUrl, callAdapter: ErrorAdapter)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  @POST(ApiUrls.login)
  @Extra({'isPublic': true})
  Future<BaseModel> login(@Field("phone") String phone);

  @POST(ApiUrls.register)
  @Extra({'isPublic': true})
  Future<BaseModel<AuthResponse>> register(@Field("phone") String phone);
  @POST(ApiUrls.verifyLogin)
  Future<BaseModel<AuthResponse>> verifyLogin(
    @Field("phone") String phone,
    @Field("code") String code,
  );
  @POST(ApiUrls.verifyOtp)
  Future<BaseModel<UserEntity>> verifyOtp(@Field("code") String code);
  @POST(ApiUrls.resendOtp)
  Future<BaseModel> resendOtp();
  @POST(ApiUrls.sso)
  Future<BaseModel<UserEntity>> googleSignIn({
    @Field("token") required String token,
    @Field("role") required String role,
  });
  @PUT(ApiUrls.updateFCMToken)
  Future<BaseModel> updateFCMToken({
    @Field("token") required String token,
    @Field("platform") required String platform,
  });
  @DELETE(ApiUrls.deleteFCMToken)
  Future<BaseModel> deleteFCMToken({@Field("token") required String token});

  // Profile Flow
  @GET(ApiUrls.fetchProfile)
  Future<BaseModel<UserEntity>> fetchProfile();
  @MultiPart()
  @POST(ApiUrls.updateProfile)
  Future<BaseModel<UserEntity>> updateProfile({
    @Part(name: "firstName") required String firstName,
    @Part(name: "lastName") required String lastName,
    @Part(name: "email") required String email,
    @Part(name: 'profilePicture') required File image,
  });

  // Trips Flow
  @GET(ApiUrls.trips)
  Future<BaseModel<RideResponse>> fetchUserTrips(
    @Query("status") String? status,
  );
  @GET(ApiUrls.tripSummary)
  Future<BaseModel<RideSummary>> fetchTripSummary(@Path("id") String id);

  // Booking Flow
  @GET(ApiUrls.availableTrips)
  Future<BaseModel<RideResponse>> fetchAvailableTrips({
    @Query("passengerSeats") int? passengerSeats,
    @Query("departureDate") String? departureDate,
    @Query("destinationCity") String? destinationCity,
    @Query("originCity") String? originCity,
    @Query("currency") String? currency,
    @Query("country") String? country,
  });
  @GET(ApiUrls.popularRoutes)
  Future<BaseModel<List<PopularRoute>>> fetchPopularRoutes(
    @Query("currency") String currency,
  );
  @POST(ApiUrls.bookingCost)
  Future<BaseModel<BookingCost>> fetchBookingCost(
    @Body() BookingRequest request,
  );
  @POST(ApiUrls.scheduleTrip)
  Future<BaseModel<BookingResponse>> scheduleTrip(
    @Body() BookingRequest request,
  );

  @POST(ApiUrls.bookPackage)
  Future<BaseModel<BookingResponse>> bookPackage(
    @Body() BookingRequest request,
  );

  @POST(ApiUrls.verifyPayment)
  Future<BaseModel> verifyPayment(
    @Field("transactionId") int transactionId,
    @Field("bookingId") int bookingId,
    @Field("reference") String reference,
  );

  @PATCH(ApiUrls.cancelTrip)
  Future<BaseModel> cancelTrip(
    @Field("reason") String reason,
    @Field("bookingId") int bookingId,
  );
}

// _data.fields.addAll(checkoutRequest
//     .toJson()
//     .entries
//     .where((entry) => entry.value != null)
//     .map((e) => MapEntry(e.key, e.value)));
//
// @override
// Future<BaseModel<CalcPrice>> calcPrice(CheckoutRequest calc) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   queryParameters.removeWhere((k, v) => v == null);
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.fields.addAll(calc
//       .toJson()
//       .entries
//       .where((entry) => entry.value != null)
//       .map((e) => MapEntry(e.key, e.value)));
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<CalcPrice>>(Options(
//     method: 'POST',
//     headers: _headers,
//     extra: _extra,
//   )
//           .compose(
//             _dio.options,
//             '/delivery/calculate-price',
//             queryParameters: queryParameters,
//             data: _data,
//           )
//           .copyWith(
//               baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<CalcPrice>.fromJson(
//     _result.data!,
//     (json) => CalcPrice.fromJson(json as Map<String, dynamic>),
//   );
//   return _value;
// }
//
// @override
// Future<BaseModel<Map<String, dynamic>>> checkout(
//   CheckoutRequest checkoutRequest,
//   List<File>? itemImages,
//   List<File>? itemImagesTwo,
// ) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   queryParameters.removeWhere((k, v) => v == null);
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.fields.addAll(checkoutRequest
//       .toJson()
//       .entries
//       .where((entry) => entry.value != null)
//       .map((e) => MapEntry(e.key, e.value)));
//   if (itemImages != null) {
//     _data.files.addAll(itemImages.map((i) => MapEntry(
//         'items[0][images][]',
//         MultipartFile.fromFileSync(
//           i.path,
//           filename: i.path.split(Platform.pathSeparator).last,
//         ))));
//   }
//   if (itemImagesTwo != null) {
//     _data.files.addAll(itemImagesTwo.map((i) => MapEntry(
//         'items[1][images][]',
//         MultipartFile.fromFileSync(
//           i.path,
//           filename: i.path.split(Platform.pathSeparator).last,
//         ))));
//   }
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<Map<String, dynamic>>>(Options(
//     method: 'POST',
//     headers: _headers,
//     extra: _extra,
//     contentType: 'multipart/form-data',
//   )
//           .compose(
//             _dio.options,
//             '/delivery/checkout',
//             queryParameters: queryParameters,
//             data: _data,
//           )
//           .copyWith(
//               baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<Map<String, dynamic>>.fromJson(
//     _result.data!,
//     (json) => (json as Map<String, dynamic>),
//   );
//   return _value;
// }
// @override
// Future<BaseModel<Map<String, dynamic>>> uploadProfilePicture(
//     File image) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.files.add(MapEntry(
//     'image',
//     MultipartFile.fromFileSync(
//       image.path,
//       filename: image.path.split(Platform.pathSeparator).last,
//       contentType: DioMediaType.parse('image/png'),
//     ),
//   ));
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<Map<String, dynamic>>>(Options(
//         method: 'POST',
//         headers: _headers,
//         extra: _extra,
//         contentType: 'multipart/form-data',
//       )
//           .compose(
//         _dio.options,
//         '/upload-profile-picture',
//         queryParameters: queryParameters,
//         data: _data,
//       )
//           .copyWith(
//           baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<Map<String, dynamic>>.fromJson(
//     _result.data!,
//         (json) => json as Map<String, dynamic>,
//   );
//   return _value;
// }

// @override
// Future<BaseModel<DynamicResponse>> uploadProof(
//     List<MultipartFile> files,
//     String errandId,
//     ) async {
//   final _extra = <String, dynamic>{};
//   final queryParameters = <String, dynamic>{};
//   final _headers = <String, dynamic>{};
//   final _data = FormData();
//   _data.files.addAll(files.map((i) => MapEntry('proof[]', i)));
//   final _result = await _dio.fetch<Map<String, dynamic>>(
//       _setStreamType<BaseModel<DynamicResponse>>(Options(
//         method: 'POST',
//         headers: _headers,
//         extra: _extra,
//         contentType: 'multipart/form-data',
//       )
//           .compose(
//         _dio.options,
//         '/errand/${errandId}/upload-proof',
//         queryParameters: queryParameters,
//         data: _data,
//       )
//           .copyWith(
//           baseUrl: _combineBaseUrls(
//             _dio.options.baseUrl,
//             baseUrl,
//           ))));
//   final _value = BaseModel<DynamicResponse>.fromJson(
//     _result.data!,
//         (json) => DynamicResponse.fromJson(json as Map<String, dynamic>),
//   );
//   return _value;
// }
