part of 'bookings_bloc.dart';

enum BookingsStatus { initial, loading, success, failure }
enum SummaryStatus { initial, loading, success, failure }

class BookingsState extends Equatable {
  final BookingsStatus status;
  final SummaryStatus summaryStatus;
  final List<Ride> trips;
  final RideSummary? tripSummary;
  final String? errorMessage;

  const BookingsState({
    this.status = BookingsStatus.initial,
    this.summaryStatus = SummaryStatus.initial,
    this.trips = const [],
    this.tripSummary,
    this.errorMessage,
  });

  BookingsState copyWith({
    BookingsStatus? status,
    SummaryStatus? summaryStatus,
    List<Ride>? trips,
    RideSummary? tripSummary,
    String? errorMessage,
  }) {
    return BookingsState(
      status: status ?? this.status,
      summaryStatus: summaryStatus ?? this.summaryStatus,
      trips: trips ?? this.trips,
      tripSummary: tripSummary ?? this.tripSummary,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    summaryStatus,
    trips,
    tripSummary,
    errorMessage,
  ];
}
