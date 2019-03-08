
import 'package:artivation/models/piece.dart';
import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/photo-grid/grid_tile_text.dart';
import 'package:artivation/ui/widgets/photo-grid/photo_grid_viewer.dart';
import 'package:artivation/utils/enum.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

typedef BannerTapCallback = void Function(Piece piece);

class GridPieceItem extends StatelessWidget {
  GridPieceItem(
      {Key key,
      @required this.piece,
      @required this.model,
      @required this.tileStyle,
      @required this.onBannerTap})
      : 
        assert(tileStyle != null),
        assert(onBannerTap != null),
        super(key: key);

  final Piece piece;
  final GridTileStyle tileStyle;
  final BannerTapCallback onBannerTap;
  final MainModel model;

  void goToProductDetail(BuildContext context) {
    print('go to the image detail');
  }

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(piece.title),
          backgroundColor: UIData.primaryColor,
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: piece.image,
            child: GridPhotoViewer(piece: piece),
          ),
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    final Widget image = GestureDetector(
        onTap: () {
          tileStyle == GridTileStyle.oneLine
              ? showPhoto(context)
              : goToProductDetail(context);
        },
        child: Image.asset(
          piece.image,
          fit:BoxFit.cover
        )
            );

    switch (tileStyle) {
      case GridTileStyle.imageOnly:
        return image;

      case GridTileStyle.oneLine:
        return GridTile(
          header: GestureDetector(
            onTap: () {
              onBannerTap(piece);
              model.updateFavorite(32, piece.id);
            },
            child: GridTileBar(
              title: GridTitleText(piece.title),
              backgroundColor: Colors.black45,
              leading: Icon(
                model.getPieceById(piece.id).isFavorite ?
                Icons.favorite: Icons.favorite_border,
                color: UIData.primaryColor,
              ),
            ),
          ),
          child: image,
        );

      case GridTileStyle.twoLine:
        return GridTile(
          footer: GestureDetector(
            onTap: () {
              onBannerTap(piece);
             model.updateFavorite(32, piece.id);
            },
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: GridTitleText(piece.title),
              subtitle: GridTitleText('\$ '+piece.price.toString()),
              trailing: Icon(
                model.getPieceById(piece.id).isFavorite ?
                Icons.favorite: Icons.favorite_border,
                color: UIData.primaryColor,
              ),
            ),
          ),
          child: image,
        );
    }
    assert(tileStyle != null);
    return null;
  }
}
