import 'package:artivation/models/artist.dart';
import 'package:artivation/utils/enum.dart';

class ArtistRepository {
  static List<Artist> loadArtists(Category category) {
    List<Artist> allArtists = <Artist>[
      Artist(
        id: 0,
        avatar: 'assets/img/robbyn.jpg',
        categories: <Category>[
          Category.beaches,
          Category.grafitti,
          Category.house
        ],
        name: 'Abdullah Marik',
        numberOfLikes: 123,
        numberOfPieces: 20,
        numberOfPiecesBought: 7,
        ratings: 4.7,
      ),
      Artist(
        id: 1,
        avatar: 'assets/img/saida.jpeg',
        categories: <Category>[
          Category.love,
          Category.insects,
          Category.cartoons
        ],
        name: 'Kate Eisten',
        numberOfLikes: 63,
        numberOfPieces: 10,
        numberOfPiecesBought: 4,
        ratings: 4.8,
      ),
      Artist(
        id: 2,
        avatar: 'assets/img/kalimwenjuma.jpg',
        categories: <Category>[
          Category.beaches,
          Category.grafitti,
          Category.house
        ],
        name: 'Abdullah Marik',
        numberOfLikes: 123,
        numberOfPieces: 20,
        numberOfPiecesBought: 7,
        ratings: 4.7,
      ),
      Artist(
        id: 3,
        avatar: 'assets/img/henry.jpeg',
        categories: <Category>[
          Category.cartoons,
          Category.nature,
          Category.house
        ],
        name: 'Hassan Abbas',
        numberOfLikes: 93,
        numberOfPieces: 100,
        numberOfPiecesBought: 47,
        ratings: 4.3,
      ),
      Artist(
        id: 4,
        avatar: 'assets/img/matty.jpeg',
        categories: <Category>[
          Category.love,
          Category.flowers,
          Category.animals
        ],
        name: 'Matias Muhando',
        numberOfLikes: 130,
        numberOfPieces: 290,
        numberOfPiecesBought: 70,
        ratings: 4.5,
      ),
      Artist(
        id: 5,
        avatar: 'assets/img/saida.jpg',
        categories: <Category>[
          Category.beaches,
          Category.love,
          Category.cartoons
        ],
        name: 'Asha Hamis',
        numberOfLikes: 193,
        numberOfPieces: 210,
        numberOfPiecesBought: 77,
        ratings: 4.9,
      ),
      Artist(
        id: 6,
        avatar: 'assets/img/jimmy.jpeg',
        categories: <Category>[
          Category.people,
          Category.insects,
          Category.house
        ],
        name: 'Jimmy E Eliau',
        numberOfLikes: 93,
        numberOfPieces: 30,
        numberOfPiecesBought: 10,
        ratings: 4.4,
      ),
      Artist(
        id: 7,
        avatar: 'assets/img/saida.jpeg',
        categories: <Category>[
          Category.love,
          Category.grafitti,
          Category.cartoons
        ],
        name: 'Saida Basief',
        numberOfLikes: 123,
        numberOfPieces: 60,
        numberOfPiecesBought: 27,
        ratings: 5,
      )
    ];
    return allArtists.toList();
  }
}
