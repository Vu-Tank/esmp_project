import 'imageModel.dart';

class Rating{
  double? rating;
  String? text;
  List<ImageModel>? feedbackImages;

  Rating({required this.rating,required this.text,required this.feedbackImages});

  @override
  String toString() {
    return 'Rating{rating: $rating, text: $text, feedbackImages: $feedbackImages}';
  }
}