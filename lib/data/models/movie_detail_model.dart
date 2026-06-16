import 'genre_model.dart';

/// Model detail lengkap untuk film.
class MovieDetailModel {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final int voteCount;
  final String? releaseDate;
  final int? runtime;
  final String? status;
  final String? tagline;
  final int? budget;
  final int? revenue;
  final String? originalLanguage;
  final List<GenreModel> genres;
  final List<String> productionCompanies;

  const MovieDetailModel({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    this.releaseDate,
    this.runtime,
    this.status,
    this.tagline,
    this.budget,
    this.revenue,
    this.originalLanguage,
    this.genres = const [],
    this.productionCompanies = const [],
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Tanpa Judul',
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'],
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      budget: json['budget'],
      revenue: json['revenue'],
      originalLanguage: json['original_language'],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e))
              .toList() ??
          [],
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) => e['name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'overview': overview,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
        'release_date': releaseDate,
        'runtime': runtime,
        'status': status,
        'tagline': tagline,
        'budget': budget,
        'revenue': revenue,
        'original_language': originalLanguage,
        'genres': genres.map((g) => g.toJson()).toList(),
        'production_companies': productionCompanies.map((name) => {'name': name}).toList(),
      };
}
