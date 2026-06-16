/// Model untuk genre film.
class GenreModel {
  final int id;
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tidak diketahui',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
