import 'package:flutter/material.dart';

class Piece {
  final int id;
  final String url;
  final double price;
  final String desc;
  final int rate;
  final int artistId;
  final int categoryId;
  final bool likeStatus;
  final int likeCounts;
  final bool cartStatus;

  Piece(
      {@required this.id,
      @required this.url,
      @required this.price,
      @required this.desc,
      @required this.rate,
      @required this.artistId,
      @required this.categoryId,
      @required this.likeStatus,
      @required this.likeCounts,
      @required this.cartStatus});
}
