import 'package:artivation/models/photo.dart';
import 'package:artivation/ui/widgets/photo-grid/grid_tile_text.dart';
import 'package:artivation/ui/widgets/photo-grid/photo_grid_viewer.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';

typedef BannerTapCallback = void Function(Photo photo);

class GridPhotoItem extends StatelessWidget {
  GridPhotoItem(
      {Key key,
      @required this.photo,
      @required this.tileStyle,
      @required this.onBannerTap})
      : assert(photo != null && photo.isValid),
        assert(tileStyle != null),
        assert(onBannerTap != null),
        super(key: key);

  final Photo photo;
  final GridTileStyle tileStyle;
  final BannerTapCallback onBannerTap;

  void goToProductDetail(BuildContext context) {
    print('go to the image detail');
  }

  void showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(photo.title),
          backgroundColor: UIData.primaryColor,
        ),
        body: SizedBox.expand(
          child: Hero(
            tag: photo.tag,
            child: GridPhotoViewer(photo: photo),
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
        child: Hero(
            key: Key(photo.assetName),
            tag: photo.tag,
            child: Image.asset(
              photo.assetName,
              fit: BoxFit.cover,
            )));

    final IconData icon =
        photo.isFavorite ? Icons.favorite : Icons.favorite_border;

    switch (tileStyle) {
      case GridTileStyle.imageOnly:
        return image;

      case GridTileStyle.oneLine:
        return GridTile(
          header: GestureDetector(
            onTap: () {
              onBannerTap(photo);
            },
            child: GridTileBar(
              title: GridTitleText(photo.title),
              backgroundColor: Colors.black45,
              leading: Icon(
                icon,
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
              onBannerTap(photo);
            },
            child: GridTileBar(
              backgroundColor: Colors.black45,
              title: GridTitleText(photo.title),
              subtitle: GridTitleText(photo.caption),
              trailing: Icon(
                icon,
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
