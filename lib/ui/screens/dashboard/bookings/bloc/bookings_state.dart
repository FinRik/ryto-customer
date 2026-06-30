part of 'bookings_bloc.dart';

enum BookingsStatus { initial, loading, success, canceled, failure }
enum CostStatus { initial, loading, success, failure }
enum SummaryStatus { initial, loading, refreshing, success, failure }

class BookingsState extends Equatable {
  final BookingsStatus status;
  final CostStatus costStatus;
  final SummaryStatus summaryStatus;
  final List<Ride> trips;
  final Map<int, BookingCost> tripCosts;
  final RideSummary? tripSummary;
  final BookingCost? bookingCost;
  final String? errorMessage;

  const BookingsState({
    this.status = BookingsStatus.initial,
    this.costStatus = CostStatus.initial,
    this.summaryStatus = SummaryStatus.initial,
    this.trips = const [],
    this.tripCosts = const {},
    this.tripSummary,
    this.bookingCost,
    this.errorMessage,
  });

  BookingsState copyWith({
    BookingsStatus? status,
    CostStatus? costStatus,
    SummaryStatus? summaryStatus,
    List<Ride>? trips,
    Map<int, BookingCost>? tripCosts,
    RideSummary? tripSummary,
    BookingCost? bookingCost,
    String? Function()? errorMessage,
  }) {
    return BookingsState(
      status: status ?? this.status,
      costStatus: costStatus ?? this.costStatus,
      summaryStatus: summaryStatus ?? this.summaryStatus,
      trips: trips ?? this.trips,
      tripCosts: tripCosts ?? this.tripCosts,
      tripSummary: tripSummary ?? this.tripSummary,
      bookingCost: bookingCost ?? this.bookingCost,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    costStatus,
    summaryStatus,
    trips,
    tripCosts,
    tripSummary,
    bookingCost,
    errorMessage,
  ];
}
