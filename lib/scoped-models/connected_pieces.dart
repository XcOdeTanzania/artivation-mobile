import 'package:artivation/api/api.dart';
import 'package:artivation/models/artist.dart';
import 'package:artivation/models/piece.dart';
import 'package:artivation/models/user.dart';
import 'package:artivation/utils/enum.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

mixin ConnectedPiecesModel on Model {
  List<Piece> _pieces = [];
  //List<Menu> _menus = [];
  int _selPieceId;
  bool _isLoading = false;
  bool _isCategory = false;

  User _authenticatedUser;
  User _authenticatedUser1;
  User _authenticatedUser2;

  // All the available pieces.
  List<Piece> _availablePieces;

  // All the available pieces.
  List<Piece> _purchasedPieces;

  // All the available artists
  List<Artist> _availableArtists;

// The currently selected category of artipieces.
  Category _selectedCategory = Category.all;
}

mixin PiecesModel on ConnectedPiecesModel {
  bool _isFavorite = false;

  List<Piece> get allPieces {
    return List.from(_pieces);
  }

  int get selectedPieceIndex {
    return _pieces.indexWhere((Piece piece) {
      return piece.id == _selPieceId;
    });
  }

  int get selectedPieceId {
    return _selPieceId;
  }

  bool get isFavorite {
    return _isFavorite;
  }

  Piece get selectedPiece {
    if (selectedPieceId == null) {
      return null;
    }

    return _pieces.firstWhere((Piece piece) {
      return piece.id == _selPieceId;
    });
  }

  void selectPiece(int pieceId) {
    _selPieceId = pieceId;
    notifyListeners();
  }
}

mixin LoginModel on ConnectedPiecesModel {
  PublishSubject<bool> _userSubject = PublishSubject();
  User get authenticatedUser {
    return _authenticatedUser;
  }

  User get authenticatedUser1 {
    return _authenticatedUser1;
  }

  User get authenticatedUser2 {
    return _authenticatedUser2;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final String userEmail = prefs.getString('email');
      final String userId = prefs.getString('id');
      final String userPhone = prefs.getString('phone');
      final String userSex = prefs.getString('sex');
      final String username = prefs.getString('username');
      final String userPhotoUrl = prefs.getString('photoUrl');

      _authenticatedUser = User(
          id: int.parse(userId),
          email: userEmail,
          token: token,
          phone: userPhone,
          photoUrl: userPhotoUrl,
          sex: userSex,
          username: username);

      _userSubject.add(true);
    }

    notifyListeners();
  }

  Future<bool> signInUser(String email, String password) async {
    _isLoading = true;
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    final http.Response response = await http.post(
      api + "login",
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    //String message = 'Something went wrong.';
    //print(responseData);
    if (responseData.containsKey('token')) {
      hasError = false;
      // message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['id'],
          email: email,
          token: responseData['token'],
          photoUrl: responseData['photo_url'],
          username: responseData['username'],
          phone: responseData['phone'],
          sex: responseData['sex']);
      _userSubject.add(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('id', responseData['id'].toString());
      prefs.setString('email', email);
      prefs.setString('token', responseData['token']);
      prefs.setString('photoUrl', responseData['photo_url']);
      prefs.setString('username', responseData['username']);
      prefs.setString('sex', responseData['sex']);
      prefs.setString('phone', responseData['phone']);
    } else {
      //message = "Error";
      hasError = true;
      print('oooooooooooo');
    }
    _isLoading = false;
    notifyListeners();
    return hasError;
  }

  Future<bool> signUpUser(
      String username, String email, String password) async {
    print(username);
    print(email);
    print(password);

    _isLoading = true;
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'username': username,
      'photo_url': 'male.png',
    };
    final http.Response response = await http.post(
      api + "signUp",
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    //String message = 'Something went wrong.';
    //print(responseData);
    if (responseData.containsKey('token')) {
      hasError = false;
      // message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['id'],
          email: email,
          token: responseData['token'],
          photoUrl: responseData['photo_url'],
          username: responseData['username'],
          phone: responseData['phone'],
          sex: responseData['sex']);
      _userSubject.add(true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('id', responseData['id'].toString());
      prefs.setString('email', email);
      prefs.setString('token', responseData['token']);
      prefs.setString('photoUrl', responseData['photo_url']);
      prefs.setString('username', responseData['username']);
      prefs.setString('sex', responseData['sex']);
      prefs.setString('phone', responseData['phone']);
    } else {
      hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return hasError;
  }

  void logout() async {
    _authenticatedUser = null;
    _userSubject.add(false);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('id');
    prefs.remove('email');
    prefs.remove('token');
    prefs.remove('photoUrl');
    prefs.remove('username');
    prefs.remove('sex');
    prefs.remove('phone');
  }
}

mixin UtilityModel on ConnectedPiecesModel {
  bool get isCategogry => _isCategory;

  Category get selectedCategory => _selectedCategory;
  //getters
  bool get isLoading {
    return _isLoading;
  }
}

mixin PieceModel on ConnectedPiecesModel {
  bool _isFavorite = false;

// Returns a copy of the list of available products, filtered by category.
  List<Piece> getPieces() {
    if (_availablePieces == null) {
      return <Piece>[];
    }

    if (_selectedCategory == Category.all) {
      return List<Piece>.from(_availablePieces);
    } else {
      return _availablePieces
          .where((Piece piece) => piece.category == _selectedCategory)
          .toList();
    }
  }

  List<Piece> gePurchasedPieces() {
    if (_purchasedPieces == null) {
      return <Piece>[];
    }

    return List<Piece>.from(_purchasedPieces);
  }

  List<Piece> getArtistPieces(int artstId) {
    return _availablePieces
        .where((Piece piece) => piece.artistId == artstId)
        .toList();
  }

  bool get isFavorite {
    return _isFavorite;
  }

  void filterFavorites() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  Future<void> updateFavorite(int userId, int pieceId) async {
    
    _togglePieceFavoriteStatus(pieceId, false);

    final Map<String, dynamic> updatePieceLikesStatus = {
      "user_id": userId,
      "piece_id": pieceId
    };

    try {
      http.Response response = await http.post(
        api + "like",
        body: json.encode(updatePieceLikesStatus),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
    } catch (error) {
      _togglePieceFavoriteStatus(pieceId, true);
    }
  }

  void _togglePieceFavoriteStatus(int pieceId, bool err) {
    final Piece piece =
        _availablePieces.firstWhere((Piece piece) => piece.id == pieceId);

    final int photoIndex = _availablePieces.indexWhere((Piece p) {
      return p.id == pieceId;
    });

    final bool isCurrentlyFavorite = piece.isFavorite;

    final bool newFavoriteStatus = !isCurrentlyFavorite;
    print(newFavoriteStatus);

    int newLikeCount = piece.likeCounts;
    print(newLikeCount);
    if (newFavoriteStatus) {
      newLikeCount++;
      print(newLikeCount);
    } else {
      newLikeCount--;
      print(newLikeCount);
    }

    final Piece updatedPiece = Piece(
        cartStatus: piece.cartStatus,
        id: piece.id,
        category: piece.category,
        image: piece.image,
        isFavorite: newFavoriteStatus,
        price: piece.price,
        artistId: piece.artistId,
        likeCounts: newLikeCount,
        desc: piece.desc,
        rate: piece.rate,
        size: piece.size,
        title: piece.title);

    _availablePieces[photoIndex] = updatedPiece;

    notifyListeners();
  }

// Returns the Piece instance matching the provided id.
  Piece getPieceById(int id) {
    return _availablePieces.firstWhere((Piece p) => p.id == id);
  }

  // Loads the list of available products from the repo.
  Future<void> fetchPieces(int userId) async {
    final List<Piece> _fetchedPieces = [];
    try {
      final http.Response response =
          await http.get(api + "pieces/" + userId.toString());
      final Map<String, dynamic> data = json.decode(response.body);
      data['pieces'].forEach((pieceData) {
        print(pieceData['id']);
        final piece = Piece.fromMap(pieceData);
        _fetchedPieces.add(piece);
      });
      print(_fetchedPieces);
    } catch (error) {
      print(error);
    }
    _availablePieces = _fetchedPieces;
    //_availablePieces = PieceRepository.loadPieces(Category.all);
    notifyListeners();
  }

  Future<void> setCategory(Category newCategory) async {
    _selectedCategory = newCategory;
    notifyListeners();
  }

  //fetch purchased pieces
  Future<void> fetchPurchasedPieces(int userId) async {
    final List<Piece> _fetchedPurchasedPieces = [];
    try {
      final http.Response response =
          await http.get(api + "pieces/purchased/" + userId.toString());
      final Map<String, dynamic> data = json.decode(response.body);

      data['pieces'].forEach((pieceData) {
        final piece = Piece.fromMap(pieceData);
        _fetchedPurchasedPieces.add(piece);
      });
      print(_fetchedPurchasedPieces);
    } catch (error) {
      print(error);
    }
    _purchasedPieces = _fetchedPurchasedPieces;
    notifyListeners();
  }
}

mixin CartModel on ConnectedPiecesModel {
  // The IDs and quantities of products currently in the cart.
  final Map<int, int> _piecesInCart = <int, int>{};

  Map<int, int> get piecesInCart => Map<int, int>.from(_piecesInCart);

  // Total number of items in the cart.
  int get totalCartQuantity =>
      _piecesInCart.values.fold(0, (int v, int e) => v + e);

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _piecesInCart.keys
        .map((int id) => _availablePieces[id].price * _piecesInCart[id])
        .fold(0.0, (double sum, int e) => sum + e);
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _piecesInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  // Removes everything from the cart.
  void clearCart() {
    _piecesInCart.clear();
    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int pieceId) {
    _piecesInCart.remove(pieceId);
    final Piece piece =
        _availablePieces.firstWhere((Piece p) => p.id == pieceId);
    final Piece updatedPiece = Piece(
        cartStatus: false,
        id: piece.id,
        category: piece.category,
        image: piece.image,
        isFavorite: piece.isFavorite,
        price: piece.price,
        artistId: piece.artistId,
        likeCounts: piece.likeCounts,
        desc: piece.desc,
        rate: piece.rate,
        size: piece.size,
        title: piece.title);
    print(updatedPiece);
    _availablePieces[pieceId] = updatedPiece;
    notifyListeners();
  }

  // Adds a photo to the cart.
  void addPieceToCart(int pieceId) {
    final Piece piece =
        _availablePieces.firstWhere((Piece piece) => piece.id == pieceId);

    if (piece.cartStatus) {
      _piecesInCart.remove(pieceId);
    } else {
      _piecesInCart[pieceId] = 1;
    }

    final bool isCurrentlyInCart = piece.cartStatus;
    final bool newCartStatus = !isCurrentlyInCart;
    final Piece updatedPiece = Piece(
        cartStatus: newCartStatus,
        id: piece.id,
        category: piece.category,
        image: piece.image,
        isFavorite: piece.isFavorite,
        price: piece.price,
        artistId: piece.artistId,
        likeCounts: piece.likeCounts,
        desc: piece.desc,
        rate: piece.rate,
        size: piece.size,
        title: piece.title);

    _availablePieces[pieceId] = updatedPiece;

    notifyListeners();
  }

  @override
  String toString() {
    return 'ConnectedPiecesModel(totalCost: $totalCost)';
  }
}

mixin ArtistModel on ConnectedPiecesModel {
  // Returns a copy of the list of available artists
  List<Artist> getArtists() {
    if (_availableArtists == null) {
      return <Artist>[];
    }

    return List<Artist>.from(_availableArtists);
  }

// Returns the Artist instance matching the provided id.
  Artist getArtistById(int id) {
    return _availableArtists.firstWhere((Artist artist) => artist.id == id);
  }

  // Loads the list of available artists from the repo.
  Future<void> fetchArtists() async {
    final List<Artist> _fetchedArtists = [];
    try {
      final http.Response response = await http.get(api + "artists");
      final Map<String, dynamic> data = json.decode(response.body);

      data['artists'].forEach((artistData) {
        print(artistData['id']);
        final artist = Artist.fromMap(artistData);
        _fetchedArtists.add(artist);
      });
    } catch (error) {
      print(error);
    }
    _availableArtists = _fetchedArtists;
    //_availablePieces = PieceRepository.loadPieces(Category.all);
    notifyListeners();
  }
}
