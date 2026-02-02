class User {
  final String id;
  final String email;
  final String pseudo;
  final String? communityId;
  final String? avatarUrl;
  final String? companyId;

  User({
    required this.id,
    required this.pseudo,
    required this.email,
    this.communityId,
    this.avatarUrl,
    this.companyId,
  });

  User copyWith({
    String? id,
    String? pseudo,
    String? email,
    String? Function()? communityId,
    String? avatarUrl,
    String? companyId,
  }) {
    return User(
      id: id ?? this.id,
      pseudo: pseudo ?? this.pseudo,
      email: email ?? this.email,
      communityId: communityId != null ? communityId() : this.communityId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      companyId: companyId ?? this.companyId,
    );
  }
}