import 'package:meta/meta.dart';
import 'package:artivation/utils/enum.dart';
import 'dart:convert';

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
  final List<int> favoriteList;

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
    @required this.favoriteList,
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
        isFavorite = map['favorite_list'] == null
            ? false
            : toList(map['favorite_list']).contains(32),
        likeCounts = map['favorite_list'] == null
            ? 0
            : toList(map['favorite_list']).length,
        cartStatus = map['cart_status'] == 1 ? true : false,
        favoriteList =
            map['favorite_list'] == null ? [] : toList(map['favorite_list']);

  static List<int> toList(String favoriteList) {
    List<int> list = List<int>.from(utf8.encode(favoriteList));
    return list;
  }
}
