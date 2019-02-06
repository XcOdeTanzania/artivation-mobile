import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/cart_page.dart';
import 'package:artivation/ui/pages/drawer_page.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';

class ArtPiece {
  const ArtPiece({
    this.assetName,
    this.title,
    this.description,
  });

  final String assetName;
  final String title;
  final List<String> description;

  bool get isValid =>
      assetName != null && title != null && description?.length == 3;
}

final List<ArtPiece> pieces = <ArtPiece>[
  const ArtPiece(
    assetName: 'assets/img/animals/animal1.jpeg',
    title: 'Dynaso',
    description: <String>[
      'Tsh 70,000/-',
      'size: 40 X 40 cm',
      'By: Sabra Love',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/beaches/beach1.jpeg',
    title: 'Motema beach',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/animals/animal6.jpeg',
    title: 'Tiger',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/beaches/beach2.jpeg',
    title: 'Mikadi beach',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/beaches/beach3.jpeg',
    title: 'Mbudya beach',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/animals/animal2.jpeg',
    title: 'Horse',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Ally',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/beaches/beach4.jpeg',
    title: 'Kibada beach',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: sheila Said',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/animals/animal3.jpeg',
    title: 'Animal Kingdom',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: John Joe',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/animals/animal4.jpeg',
    title: 'Wolf',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/beaches/beach5.jpeg',
    title: 'Robin beach',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/animals/animal5.jpeg',
    title: 'Simba',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  ),
  const ArtPiece(
    assetName: 'assets/img/animals/animal7.jpeg',
    title: 'Baby Elephant',
    description: <String>[
      'Tsh 89,000/-',
      'Size: 56 X 40 cm',
      'By: Queen Saida',
    ],
  )
];

class ArtPieceItem extends StatelessWidget {
  ArtPieceItem({Key key, @required this.piece, this.shape})
      : assert(piece != null && piece.isValid),
        super(key: key);

  static const double height = 366.0;
  final ArtPiece piece;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: height,
        child: Card(
          shape: shape,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // photo and title
              SizedBox(
                height: 184.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: GestureDetector(
                        child: Image.asset(
                          piece.assetName,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          print('Art pice has been tapped');
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 16.0,
                      left: 16.0,
                      right: 16.0,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          piece.title,
                          style: titleStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // description and share/explore buttons
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                  child: DefaultTextStyle(
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: descriptionStyle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // three line description
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            piece.description[0],
                            style: descriptionStyle.copyWith(
                                color: Colors.black54),
                          ),
                        ),
                        Text(piece.description[1]),
                        Text(piece.description[2]),
                      ],
                    ),
                  ),
                ),
              ),
              // share, explore buttons
              ButtonTheme.bar(
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        FlatButton(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          onPressed: () {
                            print('favorate');
                          },
                        ),
                        Text('140 likes')
                      ],
                    ),
                    FlatButton(
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        print('Added to cart');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PiecePage extends StatefulWidget {
  @override
  PiecePageState createState() {
    return new PiecePageState();
  }
}

class PiecePageState extends State<PiecePage> {
  ShapeBorder _shape;

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleRefresh() async {}

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: UIData.primaryColor,
            title: Text('Artivation',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  print('searching');
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ShoppingCartPage()));
                },
              ),
              model.isFavorite
                  ? IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        model.filterFavorites();
                      },
                    )
                  : Container()
            ],
          ),
          body:  LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: UIData.primaryColor,
            showChildOpacityTransition: false,
            child: ListView(
              itemExtent: ArtPieceItem.height,
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              children: pieces.map<Widget>((ArtPiece piece) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ArtPieceItem(
                    piece: piece,
                    shape: _shape,
                  ),
                );
              }).toList()), // scroll view
          ) ,
          drawer: DrawerPage(),
        );
      },
    );
  }
}
