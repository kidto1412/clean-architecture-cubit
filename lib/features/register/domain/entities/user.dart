class User {
  final int? id;
  final String name;
  final String username;
  final String password;
  final String email;
  final String? photo_profile;
  final DateTime? created_at;
  final DateTime? updated_at;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
    this.photo_profile,
    required this.created_at,
    required this.updated_at,
  });

  @override
  List<Object> get props => [
        id ?? 0,
        name,
        username,
        email,
        password,
        photo_profile ?? '',
        created_at ?? '',
        updated_at ?? '',
      ];
}
