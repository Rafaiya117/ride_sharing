class ReviewModel {
  final String passengerName;
  final String initials;
  final String date;
  final double rating;
  final String comment;

  ReviewModel({
    required this.passengerName, required this.initials, required this.date,
    required this.rating, required this.comment,
  });
}