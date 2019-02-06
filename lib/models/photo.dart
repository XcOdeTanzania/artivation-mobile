enum GridTileStyle {
  imageOnly,
  oneLine,
  twoLine
}

class Photo {
  Photo({
    this.assetName,
    this.title,
    this.caption,
    this.isFavorite = false,
  });

  final String assetName;
  final String title;
  final String caption;

  bool isFavorite;
  String get tag => assetName; 

  bool get isValid => assetName != null && title != null && caption != null && isFavorite != null;
}