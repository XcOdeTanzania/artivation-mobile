import 'package:artivation/models/artist.dart';
import 'package:artivation/models/piece.dart';
import 'package:artivation/models/repos/artist_repository.dart';
import 'package:artivation/models/repos/piece_repository.dart';
import 'package:artivation/utils/enum.dart';
import 'package:scoped_model/scoped_model.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

mixin ConnectedPiecesModel on Model {
  List<Piece> _pieces = [];
  //List<Menu> _menus = [];
  int _selPieceId;
  bool _isLoading = false;
  bool _isCategory = false;

  bool _isLoggedIn = false;

  // All the available pieces.
  List<Piece> _availablePieces;

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

mixin UserModel on ConnectedPiecesModel {}

mixin UtilityModel on ConnectedPiecesModel {
  bool get isCategogry => _isCategory;

  Category get selectedCategory => _selectedCategory;
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

  bool get isFavorite {
    return _isFavorite;
  }

  void filterFavorites() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void togglePieceFavoriteStatus(int pieceId) {
    final Piece piece =
        _availablePieces.firstWhere((Piece piece) => piece.id == pieceId);

    final bool isCurrentlyFavorite = piece.isFavorite;
    print(piece.isFavorite);
    print('Then');
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    print(newFavoriteStatus);

    int newLikeCount = piece.likeCounts;
    if (newFavoriteStatus) {
      newLikeCount++;
    } else {
      newLikeCount--;
    }
    print(newLikeCount);

    print(newFavoriteStatus);

    final Piece updatedPiece = Piece(
        cartStatus: piece.cartStatus,
        id: piece.id,
        category: piece.category,
        image: piece.image,
        isFavorite: newFavoriteStatus,
        price: piece.price,
        artistName: piece.artistName,
        likeCounts: newLikeCount,
        desc: piece.desc,
        rate: piece.rate,
        size: piece.size,
        title: piece.title);

    _availablePieces[pieceId] = updatedPiece;

    notifyListeners();
  }

// Returns the Piece instance matching the provided id.
  Piece getPieceById(int id) {
    return _availablePieces.firstWhere((Piece p) => p.id == id);
  }

  // Loads the list of available products from the repo.
  void loadPieces() {
    _availablePieces = PieceRepository.loadPieces(Category.all);
    notifyListeners();
  }

  Future<void> setCategory(Category newCategory) async {
    _selectedCategory = newCategory;
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
        artistName: piece.artistName,
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
        artistName: piece.artistName,
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
  void loadArtists() {
    _availableArtists = ArtistRepository.loadArtists(Category.all);
    notifyListeners();
  }
}
