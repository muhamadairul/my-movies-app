/// Model untuk cast/crew film.
class CastModel {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int? order;

  const CastModel({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
    this.order,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) {
    return CastModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Tidak diketahui',
      character: json['character'],
      profilePath: json['profile_path'],
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'character': character,
        'profile_path': profilePath,
        'order': order,
      };
}
