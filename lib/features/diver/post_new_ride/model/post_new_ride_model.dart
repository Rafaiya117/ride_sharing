class PostRideModel {
  String pickupLocation;
  String dropoffLocation;
  String date;
  String time;
  int availableSeats;
  double pricePerSeat;
  bool isDoorPickUp;
  bool isDoorDropOff;
  double? pickupCharges;
  double? dropoffCharges;

  PostRideModel({
    this.pickupLocation = '',
    this.dropoffLocation = '',
    this.date = '',
    this.time = '',
    this.availableSeats = 1,
    this.pricePerSeat = 45.0,
    this.isDoorPickUp = false,
    this.isDoorDropOff = false,
  });
}