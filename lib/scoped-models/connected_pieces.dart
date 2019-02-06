import 'dart:async';
import 'dart:convert';

import 'package:artivation/api/api.dart';
import 'package:artivation/models/auth.dart';
import 'package:artivation/models/menu.dart';
import 'package:artivation/models/piece.dart';
import 'package:artivation/models/product.dart';
import 'package:artivation/models/product_repository.dart';
import 'package:artivation/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;


mixin ConnectedPiecesModel on Model {
  List<Piece> _pieces = [];
  List<Menu> _menus = [];
  int _selPieceId;
  User _authenticatedUser;
  bool _isLoading = false;

  bool _isLoggedIn = false;

//######################################################
//temporary code to all incoparate 

// All the available products.
  List<Product> _availableProducts;

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

// The IDs and quantities of products currently in the cart.
  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity => _productsInCart.values.fold(0, (int v, int e) => v + e);

  Category get selectedCategory => _selectedCategory;


  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys
      .map((int id) => _availableProducts[id].price * _productsInCart[id])
      .fold(0.0, (double sum, int e) => sum + e);
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem * _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

// Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return <Product>[];
    }

    if (_selectedCategory == Category.all) {
      return List<Product>.from(_availableProducts);
    } else {
      return _availableProducts
        .where((Product p) => p.category == _selectedCategory)
        .toList();
    }
  }

   // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

 // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

 // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((Product p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }

@override
  String toString() {
    return 'ConnectedPiecesModel(totalCost: $totalCost)';
  }

  //######################################################################
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

  void filterFavorites() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }
}

mixin UserModel on ConnectedPiecesModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(api + "login",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.post(api + "signUp",
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong';
    print(responseData);
    if (responseData.containsKey('token')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['id'], email: email, token: responseData['token']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['id']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final int userId = int.parse(prefs.getString('userId'));
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

//menu mixin...........
mixin MenuModel on ConnectedPiecesModel {
  Menu _menu;

  Menu get menu {
    return _menu;
  }

  List<Menu> get allMenus {
    return List.from(_menus);
  }
}
mixin UtilityModel on ConnectedPiecesModel {
  //getters
  bool get isLoading {
    return _isLoading;
  }

  //temory login
  bool get isLoggedIn {
    return _isLoggedIn;
  }

  //Temporary login
  void userLogin() {
    _isLoggedIn = !_isLoggedIn;
    notifyListeners();
  }
}
