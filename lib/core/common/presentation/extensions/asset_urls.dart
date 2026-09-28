import 'package:oikos/core/common/domain/entities/user.dart';
import 'package:oikos/core/utils/utils.dart';
import 'package:oikos/features/admin/domain/models/models.dart';

extension CompanyExtension on Company {
  String get logoNetworkUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? StorageUtils.getNetworkUrl('logos', logoUrl!)
      : StorageUtils.getNetworkUrl('avatars', 'avatar_1.png');

  String get logoLocalUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? StorageUtils.getLocalUrl('logos', logoUrl!)
      : StorageUtils.getNetworkUrl('avatars', 'avatar_1.png');
}

extension CommunityExtension on Community {
  String get avatarNetworkUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? StorageUtils.getNetworkUrl('avatars', logoUrl!)
      : StorageUtils.getNetworkUrl('avatars', 'avatar_1.png');

  String get avatarLocalUrl => logoUrl != null && logoUrl!.isNotEmpty
      ? StorageUtils.getLocalUrl('avatars', logoUrl!)
      : StorageUtils.getNetworkUrl('avatars', 'avatar_1.png');
}

extension UserAvatar on UserEntity {
  String get avatarNetworkUrl => avatar == null || avatar!.isEmpty
      ? StorageUtils.getNetworkUrl('avatars', 'avatar_1.png')
      : avatar!.startsWith('http')
      ? avatar!
      : StorageUtils.getNetworkUrl(
          'avatars',
          avatar!.replaceFirst('assets/avatars/', ''),
        );
  String get avatarLocalUrl => avatar == null || avatar!.isEmpty
      ? 'assets/avatars/avatar_1.png'
      : avatar!.startsWith('assets/')
      ? avatar!
      : StorageUtils.getLocalUrl('avatars', avatar!);
}
