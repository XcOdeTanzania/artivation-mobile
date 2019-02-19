import 'package:meta/meta.dart';
import 'package:artivation/utils/enum.dart';


class Piece {
  final int id;
  final String image;
  final int price;
  final String title;
  final String size;
  final String desc;
  final int rate;
  final String artistName;
  final Category category;
  final bool isFavorite;
  final int likeCounts;
  final bool cartStatus;

  Piece(
      {@required this.id,
      @required this.title,
      @required this.size,
      @required this.image,
      @required this.price,
      @required this.desc,
      @required this.rate,
      @required this.artistName,
      @required this.category,
      @required this.isFavorite,
      @required this.likeCounts,
      @required this.cartStatus});
}
