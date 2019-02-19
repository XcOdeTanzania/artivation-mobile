import 'package:scoped_model/scoped_model.dart';
import 'package:artivation/scoped-models/connected_pieces.dart';

class MainModel extends Model
    with
        ConnectedPiecesModel,
        UserModel,
        PieceModel,
        UtilityModel,
        ArtistModel,
        CartModel {}
