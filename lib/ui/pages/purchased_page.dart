import 'package:artivation/models/piece.dart';
import 'package:artivation/scoped-models/main.dart';
import 'package:artivation/ui/widgets/photo-grid/grid_photo_item.dart';
import 'package:artivation/utils/enum.dart';
import 'package:artivation/utils/ui_data.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';

class PurchasedGridList extends StatefulWidget {
  const PurchasedGridList({Key key, this.model}) : super(key: key);

  final MainModel model;
  @override
  PurchasedGridListState createState() => PurchasedGridListState();
}

class PurchasedGridListState extends State<PurchasedGridList> {
  GridTileStyle _tileStyle = GridTileStyle.oneLine;

  bool _noNetwork = false;
  bool _hasError = false;
  bool _showLoading = false;
  double _height ;
  var connectivityResult =  Connectivity().checkConnectivity();
  void fetchData(){
    widget.model.fetchPurchasedPieces(widget.model.authenticatedUser.id);
    connectivityResult.then((value){
      if (value == ConnectivityResult.mobile ||
          value == ConnectivityResult.wifi) {
        setState(() {
          _showLoading = true;
        });
        widget.model.fetchPurchasedPieces(widget.model.authenticatedUser.id).then((response) {
          setState(() {
            _showLoading = false;
            if (response.containsKey('error')) _hasError = true;
            if(response.containsKey('noInternet')) _noNetwork = true;
          });
        });
      } else {
        setState(() {
          _showLoading = false;
          _hasError = false;
          _noNetwork = true;
        });
      }
    });
  }

  @override
  void initState() {
    //widget.model.fetchPurchasedPieces(widget.model.authenticatedUser.id);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    _height = MediaQuery.of(context).size.height/3;
    Future<Null> _handleRefresh() async {
    //widget.model.fetchPurchasedPieces(widget.model.authenticatedUser.id);
      fetchData();
    }

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Purchased',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontFamily: "WorkSansSemiBold")),
            backgroundColor: UIData.primaryColor,
          ),
          body: _showLoading ?
          ListView(
            children: <Widget>[
              SizedBox(
                height: _height,
              ),
              Center(
                child: CircularProgressIndicator(
                  backgroundColor: UIData.primaryColor,
                  valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          )
              : LiquidPullToRefresh(
            onRefresh: _handleRefresh,
            color: UIData.primaryColor,
            showChildOpacityTransition: false,
            child:
            model.gePurchasedPieces().length >0 ?
            GridView.builder(
              itemCount: model.gePurchasedPieces().length,
              itemBuilder: (context, index) {
                return GridPieceItem(
                  onBannerTap: (Piece piece) {
                    print(model.gePurchasedPieces().length);
                  },
                  piece: model.gePurchasedPieces()[index],
                  tileStyle: _tileStyle,
                  model: model,
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio:
                      (orientation == Orientation.portrait) ? 1.0 : 1.3),
              padding: const EdgeInsets.all(4.0),
            ):
            ListView(
              children: <Widget>[
                SizedBox(
                  height: _height,
                ),
                Center(
                  child: _noNetwork ? Text('NO INTERNET CONNECTION,CHECK YOUR INTERNET'):
                      _hasError ? Text('ERROR OCCURED') :
                      Text('YOU DON\'T HAVE PURCHESED ITEMS'),

                ),
              ],
            )
            , // scroll view
          ),
        );
      },
    );
  }
}
