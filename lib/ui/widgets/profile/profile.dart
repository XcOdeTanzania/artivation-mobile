import 'package:artivation/models/artist.dart';
import 'package:artivation/ui/pages/gallery_page.dart';
import 'package:artivation/ui/widgets/profile/chip_tile.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';

// const List<String> _defaultMaterials = <String>[
//   'People',
//   'Animation',
//   'Nature',
//   'grafiti',
//   'Love',
// ];

class Profile extends StatefulWidget {
  final Artist artist;
  

  const Profile({Key key, this.artist}) : super(key: key); 
  @override
  ProfileState createState() {
    return new ProfileState(artist);
  }
}

class ProfileState extends State<Profile> {
  List<String> cats;
  final Artist myArtist;
  ProfileState(this.myArtist) {
    _reset();
  }
  final Set<String> _materials = Set<String>();

  String _selectedMaterial = '';
  double rating = 4.5;
  int starCount = 5;

  void _reset() {
    _materials.clear();
    List<String> _defaultMaterials = <String>[
      myArtist.categories[0].toString().replaceAll('Category.', ''),
      myArtist.categories[1].toString().replaceAll('Category.', ''),
      myArtist.categories[2].toString().replaceAll('Category.', ''),
    ];
   
    _materials.addAll(_defaultMaterials);
  }

  String _capitalize(String name) {
    assert(name != null && name.isNotEmpty);
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  Color _nameToColor(String name) {
    assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  Widget galleryButton() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
      child: MaterialButton(
          color: UIData.primaryColor,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
            child: Text(
              "Gallery",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: "WorkSansBold"),
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GalleryGridList()));
          }),
    );
  }

  Widget starRatings() {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text('Ratings'),
          )),
      Padding(
        padding: EdgeInsets.only(
          bottom: 10.0,
        ),
        child: StarRating(
          size: 50.0,
          rating: widget.artist.ratings,
          color: Colors.orange,
          borderColor: Colors.grey,
          starCount: starCount,
          onRatingChanged: (rating) => setState(
                () {
                  this.rating = rating;
                },
              ),
        ),
      ),
      Text(
        "$rating",
        style: new TextStyle(fontSize: 30.0),
      )
    ]);
  }

  Widget topHalf(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Container(
        color: UIData.secondaryColor,
        padding: EdgeInsets.only(top: 30),
        child: Column(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width / 8,
                backgroundImage: AssetImage(widget.artist.avatar),
              ),
            ),
            Text(
              widget.artist.name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget bottomHalf(BuildContext context) {
    final List<Widget> choiceChips = _materials.map<Widget>((String name) {
      return ChoiceChip(
        key: ValueKey<String>(name),
        backgroundColor: _nameToColor(name),
        label: Text(_capitalize(name)),
        selected: _selectedMaterial == name,
        onSelected: (bool value) {
          setState(() {
            _selectedMaterial = value ? name : '';
          });
        },
      );
    }).toList();

    final List<Widget> tiles = <Widget>[
      const SizedBox(height: 8.0, width: 0.0),
      ChipsTile(label: 'Categories', children: choiceChips),
      starRatings(),
      galleryButton()
    ];

    return Flexible(
      flex: 4,
      child: Container(
        color: Colors.white,
        child: ListView(padding: EdgeInsets.only(top: 20), children: tiles),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[topHalf(context), bottomHalf(context)],
    );
  }
}
