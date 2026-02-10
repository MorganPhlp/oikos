import 'package:oikos/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../../domain/repository/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> getMyPseudo() async {
    try {
      final pseudo = await remoteDataSource.getMyPseudo();
      return right(pseudo);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
