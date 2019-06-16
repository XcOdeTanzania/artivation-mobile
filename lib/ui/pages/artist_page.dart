import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/pages/artist_detail_page.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:connectivity/connectivity.dart';

class ArtistPage extends StatefulWidget {
  final MainModel model;

  ArtistPage(this.model);

  @override
  _ArtistState createState() => _ArtistState();
}

class _ArtistState extends State<ArtistPage> {
  bool _hasError = false;
  bool _noNetwork = false;
  bool _shoLoading = false;

  double _height;

//  var connectivityResult =  Connectivity().checkConnectivity();
  @override
  void initState() {
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none)
        setState(() {
          _noNetwork = true;
        });
      else {
        setState(() {
          _shoLoading = true;
        });
        widget.model.fetchArtists().then((response) {
          setState(() {
            _shoLoading = false;
            if (response.containsKey('error')) _hasError = true;
            if (response.containsKey('noInternet')) _noNetwork = true;
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height / 3;
    Future<Null> _handleRefresh() async {
      Connectivity().checkConnectivity().then((value) {
        if (value == ConnectivityResult.mobile ||
            value == ConnectivityResult.wifi) {
          setState(() {
            _shoLoading = true;
          });
          widget.model.fetchArtists().then((response) {
            setState(() {
              _shoLoading = false;
              if (response.containsKey('error'))
                _hasError = true;
              else
                _hasError = false;
              if (response.containsKey('noInternet'))
                _noNetwork = true;
              else
                _noNetwork = false;
            });
          });
        } else {
          setState(() {
            _noNetwork = true;
          });
        }
      });
//      print(widget.model.getArtists().length);
    }

    Widget _listEmptyWidget = ListView(
      children: <Widget>[
        SizedBox(
          height: _height,
        ),
        Center(
          child: Text('No Artist Found!'),
        ),
      ],
    );

    Widget _noNetworkWidget = ListView(
      children: <Widget>[
        SizedBox(
          height: _height,
        ),
        Center(child: Text('No Internet!, Check your Internet connection'))
      ],
    );

    Widget _loadingWidget = ListView(
      children: <Widget>[
        SizedBox(
          height: _height,
        ),
        Center(
          child: CircularProgressIndicator(
            backgroundColor: UIData.primaryColor,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ],
    );

    Widget _errorWidget = ListView(
      children: <Widget>[
        SizedBox(
          height: _height,
        ),
        Center(
            child: Text('Error Occured !, Make sure you connected to Internet'))
      ],
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
//        if (_noNetwork)
//          _content = ListView(
//            children: <Widget>[
//              Center(
//                  child: Text('No Internet!, Check your Internet connection'))
//            ],
//          );
//
//        if (_hasError)
//          _content = ListView(
//            children: <Widget>[
//              Center(
//                  child: Text(
//                      'Error Occured !, Make sure you connected to Internet'))
//            ],
//          );
//        if (model.getArtists().length > 0)
//          _content = _shoLoading ?  _buildListOfArtists(model);
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

            child: _shoLoading
                ? _loadingWidget
                : _noNetwork
                    ? _noNetworkWidget
                    : _hasError
                        ? _errorWidget
                        : model.getArtists().length > 0
                            ? _buildListOfArtists(model)
                            : _listEmptyWidget, // scroll view
          ),
        );
      },
    );
  }
}
