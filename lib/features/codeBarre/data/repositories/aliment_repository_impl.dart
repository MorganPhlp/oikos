import 'package:fpdart/fpdart.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/aliment_entity.dart';
import '../../domain/repositories/aliment_repository.dart';
import '../datasources/code_barre_remote_data_source.dart';

/*
*
*Appelle le DataSource, attrape les erreurs s’il y en a,
*  et renvoie le résultat propre (Soit un Succès, soit un Échec)
au reste de l’application.
*
* */


class AlimentRepositoryImpl implements AlimentRepository {
  final CodeBarreRemoteDataSource remoteDataSource;

  AlimentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, AlimentEntity>> getAlimentByCode(String codeBarre) async {
    try {
      final aliment = await remoteDataSource.getAliment(codeBarre);
      return Right(aliment);
    } on ServerException {
      // On capture l'exception et on renvoie au travers de Failure
      return Left(Failure('Impossible de récupérer le produit.'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}