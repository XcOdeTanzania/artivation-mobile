import 'package:artivation/models/photo.dart';
import 'package:artivation/ui/widgets/photo-grid/grid_photo_item.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';




class GalleryGridList extends StatefulWidget {
  const GalleryGridList({ Key key }) : super(key: key);

  static const String routeName = '/material/grid-list';

  @override
  GalleryGridListState createState() => GalleryGridListState();
}

class GalleryGridListState extends State<GalleryGridList> {
  GridTileStyle _tileStyle = GridTileStyle.twoLine;

  List<Photo> photos = <Photo>[
    Photo(
      assetName: 'assets/img/beaches/beach1.jpeg',
      title: 'Mbudja',
      caption: 'Tsh 179,000/-',
    ),
    Photo(
      assetName: 'assets/img/beaches/beach2.jpeg',
      title: 'Coco beach',
      caption: 'Tsh 20,000/-',
    ),
    Photo(
      assetName: 'assets/img/beaches/beach3.jpeg',
      title: 'Mikadi beach',
      caption: 'Tsh 79,000/-',
    ),
    Photo(
      assetName: 'assets/img/beaches/beach4.jpeg',
      title: 'Dynaso',
      caption: 'Tsh 40,000/-',
    ),
    Photo(
      assetName: 'assets/img/beaches/beach5.jpeg',
      title: 'Horse',
      caption: 'Tsh 79,000/-',
    ),
    Photo(
      assetName: 'assets/img/animals/animal1.jpeg',
      title: 'Pondicherry',
      caption: 'Salt Farm',
    ),
    Photo(
      assetName: 'assets/img/animals/animal2.jpeg',
      title: 'Animal Kingdom',
      caption: 'Tsh 90,000/-',
    ),
    Photo(
      assetName: 'assets/img/animals/animal3.jpeg',
      title: 'Chettinad',
      caption: 'Silk Maker',
    ),
    Photo(
      assetName: 'assets/img/animals/animal4.jpeg',
      title: 'Wolf',
      caption: 'Tsh 72,000/-',
    ),
    Photo(
      assetName: 'assets/img/animals/animal5.jpeg',
      title: 'Simba',
      caption: 'Tsh 179,000/-',
    ),
    Photo(
      assetName: 'assets/img/animals/animal6.jpeg',
      title: 'Tiger',
      caption: 'Tsh 60,000/-',
    ),
    Photo(
      assetName: 'assets/img/animals/animal7.jpeg',
      title: 'Baby Elphant',
      caption: 'Tsh 79,000/-',
    ),
  ];

  void changeTileStyle(GridTileStyle value) {
    setState(() {
      _tileStyle = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontFamily: "WorkSansSemiBold")
        ),
        backgroundColor: UIData.primaryColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                padding: const EdgeInsets.all(4.0),
                childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
                children: photos.map<Widget>((Photo photo) {
                  return GridPhotoItem(
                    photo: photo,
                    tileStyle: _tileStyle,
                    onBannerTap: (Photo photo) {
                      setState(() {
                        photo.isFavorite = !photo.isFavorite;
                      });
                    }
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
