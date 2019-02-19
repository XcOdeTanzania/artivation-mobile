import 'package:artivation/models/piece.dart';
import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class PieceItem extends StatelessWidget {
  PieceItem({Key key, @required this.piece, this.shape}) : super(key: key);

  static const double height = 366.0;
  final Piece piece;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
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
                            piece.image,
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
                              piece.price.toString(),
                              style: descriptionStyle.copyWith(
                                  color: Colors.black54),
                            ),
                          ),
                          Text(piece.size),
                          Text(piece.artistName),
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
                                  model.getPieceById(piece.id).isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            onPressed: () {
                              print(piece.id);
                              model.togglePieceFavoriteStatus(piece.id);
                              //print(model.getPieceById(piece.id).isFavorite) ;
                            },
                          ),
                          Text(model
                                  .getPieceById(piece.id)
                                  .likeCounts
                                  .toString() +
                              ' likes')
                        ],
                      ),
                      FlatButton(
                        child: Icon(
                          Icons.shopping_cart,
                          color: model.getPieceById(piece.id).cartStatus
                              ? UIData.primaryColor
                              : Colors.black,
                        ),
                        onPressed: () {
                          model.addPieceToCart(piece.id);
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
    });
  }
}
