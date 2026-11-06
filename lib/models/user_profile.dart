class UserProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String postalCode;
  final String memberTier;
  final int points;
  final String avatarUrl;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.city = "Jakarta Barat",
    this.postalCode = "11530",
    this.memberTier = "Sahabat Petani Gold",
    this.points = 450,
    this.avatarUrl = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80",
  });

  factory UserProfile.fromSupabase(
    Map<String, dynamic> map, {
    String? email,
    Map<String, dynamic>? addressMap,
  }) {
    final rawAvatar = map['avatar_url'] as String?;
    final avatar = (rawAvatar != null && rawAvatar.trim().isNotEmpty)
        ? rawAvatar.trim()
        : "https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80";

    return UserProfile(
      id: map['id']?.toString() ?? '',
      name: (map['full_name'] as String?)?.trim() ?? 'Sahabat KEBUNIN',
      email: email ?? '',
      phone: (map['phone'] as String?)?.trim() ??
          (addressMap?['phone'] as String?)?.trim() ??
          '0812-3456-7890',
      address: (addressMap?['full_address'] as String?)?.trim() ??
          'Jl. Kebon Jeruk Indah No. 12',
      city: (addressMap?['city'] as String?)?.trim() ?? 'Jakarta Barat',
      postalCode: (addressMap?['postal_code'] as String?)?.trim() ?? '11530',
      memberTier: "Sahabat Petani Gold",
      points: 450,
      avatarUrl: avatar,
    );
  }

  Map<String, dynamic> toProfileMap() {
    return {
      'id': id,
      'full_name': name,
      'phone': phone,
      'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? postalCode,
    String? memberTier,
    int? points,
    String? avatarUrl,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      memberTier: memberTier ?? this.memberTier,
      points: points ?? this.points,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
