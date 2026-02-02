import 'package:oikos/features/admin/domain/interfaces/user_rep.dart';
import 'package:oikos/features/admin/domain/entities/user.dart';

class UpdateUser {
  final UserRep repository;

  UpdateUser(this.repository);

  Future<void> call(User user) async {
    // Logique métier : par exemple, empêcher un pseudo trop court
    if (user.pseudo.length < 3) {
      throw Exception("Le pseudo est trop court");
    }

    return await repository.updateUser(user);
  }
}
