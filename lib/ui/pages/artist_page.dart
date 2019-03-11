import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/artist_detail_page.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class ArtistPage extends StatefulWidget {
  final MainModel model;

  ArtistPage(this.model);

  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<ArtistPage> {
  @override
  void initState() {
    widget.model.fetchArtists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleRefresh() async {
      widget.model.fetchArtists();
      print(widget.model.getArtists().length);
    }

    Widget _content = ListView(
      children: <Widget>[Center(child: Text('No Artist Found!'))],
    );

    Widget _buildListOfArtists(MainModel model) => ListView.builder(
          padding: EdgeInsets.all(8.0),
          shrinkWrap: true,
          itemCount: model.getArtists().length,
          itemBuilder: (context, index) {
            return Container(
              child: MergeSemantics(
                child: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    radius: 36.0,
                    backgroundImage:
                        NetworkImageWithRetry(model.getArtists()[index].avatar),
                  ),
                  title: Text(model.getArtists()[index].name),
                  subtitle: Text(model
                          .getArtists()[index]
                          .categories[0]
                          .toString()
                          .replaceAll('Category.', '') +
                      model
                          .getArtists()[index]
                          .categories[1]
                          .toString()
                          .replaceAll('Category.', ', ') +
                      ' and ' +
                      model
                          .getArtists()[index]
                          .categories[2]
                          .toString()
                          .replaceAll('Category.', '')),
                  onTap: () {
                    print('card Tapped');
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArtistDetail(
                                  artist: model.getArtists()[index],
                                )));
                  },
                ),
              ),
            );
          },
        );

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        _content = _buildListOfArtists(model);
        return Scaffold(
          appBar: AppBar(
            title: Text('Artists',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
            backgroundColor: UIData.primaryColor,
          ),
          body: LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            showChildOpacityTransition: false,
            color: UIData.primaryColor,

            child: _content, // scroll view
          ),
        );
      },
    );
  }
}
