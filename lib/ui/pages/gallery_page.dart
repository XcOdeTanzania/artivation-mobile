import 'package:artivation/models/artist.dart';
import 'package:artivation/models/piece.dart';
import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/photo-grid/grid_photo_item.dart';
import 'package:artivation/utils/enum.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class GalleryGridList extends StatefulWidget {
  const GalleryGridList({Key key, this.sender, this.artist}) : super(key: key);

  static const String routeName = '/material/grid-list';
  final String sender;
  final Artist artist;

  @override
  GalleryGridListState createState() => GalleryGridListState();
}

class GalleryGridListState extends State<GalleryGridList> {
  GridTileStyle _tileStyle = GridTileStyle.twoLine;

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Gallery',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
            backgroundColor: UIData.primaryColor,
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: GridView.builder(
                    itemCount: widget.sender == "artist"
                        ? model.getArtistPieces(widget.artist.id).length
                        : model.getPieces().length,
                    itemBuilder: (context, index) {
                      return GridPieceItem(
                        onBannerTap: (Piece piece) {},
                        piece: widget.sender == "artist"
                            ? model.getArtistPieces(widget.artist.id)[index]
                            : model.getPieces()[index],
                        tileStyle: _tileStyle,
                        model: model,
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 4.0,
                        childAspectRatio:
                            (orientation == Orientation.portrait) ? 1.0 : 1.3),
                    padding: const EdgeInsets.all(4.0),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
