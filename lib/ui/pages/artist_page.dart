import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/artist_detail_page.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

const String _kAsset0 = 'assets/robbyn.jpg';

class ArtistPage extends StatefulWidget {
  final MainModel model;

  ArtistPage(this.model);

  static const List<String> _artistListContents = <String>[
    'John Paul',
    'Ally Labby',
    'Henry Pox',
    'Danny Inch',
    'Eliliana Naps',
    'Fanuel Osbert',
    'John Paul',
    'Ally Labby',
    'Henry Pox',
    'Danny Inch',
    'Eliliana Naps',
    'Fanuel Osbert',
  ];

  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<ArtistPage> {
  @override
  void initState() {
    //widget.model.fetchArtists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<Null> _handleRefresh() async {}
    Widget _content = ListView(
      children: <Widget>[Center(child: Text('No Artist Found!'))],
    );

    Widget _buildListOfArtists(MainModel model) => ListView(
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(8.0),
          children: ArtistPage._artistListContents.map<Widget>((String id) {
            return MergeSemantics(
              child: ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(16.0),
                leading: CircleAvatar(
                  radius: 36.0,
                  backgroundImage: AssetImage(_kAsset0),
                ),
                title: Text(id),
                subtitle: Text(
                    'Cartoons and Wild life'),
                onTap: () {
                  print('card Tapped');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ArtistDetail()));
                },
              ),
            );
          }).toList(),
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
