import 'package:artivation/utils/enum.dart';
import 'package:meta/meta.dart';

class Artist {
  final int id;
  final String name;
  final String avatar;
  final int numberOfPieces;
  final int numberOfPiecesBought;
  final int numberOfLikes;
  final List<Category> categories;
  final double ratings;

  Artist(
      {@required this.id,
      @required this.name,
      @required this.avatar,
      @required this.numberOfPieces,
      @required this.numberOfPiecesBought,
      @required this.numberOfLikes,
      @required this.categories,
      @required this.ratings});
}
