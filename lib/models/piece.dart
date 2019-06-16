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
  final int artistId;
  final Category category;
  final bool isFavorite;
  final int likeCounts;
  final bool cartStatus;
  

  Piece({
    @required this.id,
    @required this.title,
    @required this.size,
    @required this.image,
    @required this.price,
    @required this.desc,
    @required this.rate,
    @required this.artistId,
    @required this.category,
    @required this.isFavorite,
    @required this.likeCounts,
    @required this.cartStatus,
    
  });

  Piece.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['title'] != null),
        assert(map['size'] != null),
        assert(map['image'] != null),
        id = map['id'],
        title = map['title'],
        size = map['size'],
        image = map['image'],
        price = map['price'],
        desc = map['desc'],
        rate = map['rate'],
        artistId = map['artist_id'],
        category = Category.values[map['category_id']],
        isFavorite = map['like_status'],
        likeCounts = map['like_counts'],
        cartStatus = map['cart_status'] is bool ? map['cart_status'] : map['cart_status'] == 0 ? false : true;


}
