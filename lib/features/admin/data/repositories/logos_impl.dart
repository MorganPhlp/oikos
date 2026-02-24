import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/features/admin/domain/repositories/logos_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogosImpl extends LogosRep {
  final SupabaseClient supabase;

  LogosImpl(this.supabase);
  @override
  Future<Either<Failure, List<String>>> getLogos(String companyName) async {
    try {
      // 1. Lister tous les fichiers dans le bucket 'logos'
      final List<FileObject> objects = await supabase.storage
          .from('logos')
          .list(path: companyName.toLowerCase()); 
      

      // 2. Retourner les chemins relatifs (ex: viveris/logo.png)
      final List<String> urls = objects
          .where(
            (file) => !file.name.startsWith('.'),
          ) // Exclure les fichiers cachés
          .map((file) => '${companyName.toLowerCase()}/${file.name}')
          .toList();

      logger.d("${urls.length} logos récupérés avec succès");
      return right(urls);
    } on StorageException catch (e) {
      logger.e("Erreur Storage Supabase", error: e);
      return left(Failure(e.message));
    } catch (e) {
      logger.e("Erreur inattendue", error: e);
      return left(Failure("Impossible de charger les logos"));
    }
  }
  @override
  Future<Either<Failure, List<String>>> getAvatars() async {
    try {
      // 1. Lister tous les fichiers dans le bucket 'logos'
      final List<FileObject> objects = await supabase.storage
          .from('avatars')
          .list();
      

      // 2. Retourner les chemins relatifs (ex: avatar1.png)
      final List<String> urls = objects
          .where(
            (file) => !file.name.startsWith('.'),
          ) // Exclure les fichiers cachés
          .map((file) => file.name)
          .toList();

      logger.d("${urls.length} avatars récupérés avec succès");
      return right(urls);
    } on StorageException catch (e) {
      logger.e("Erreur Storage Supabase", error: e);
      return left(Failure(e.message));
    } catch (e) {
      logger.e("Erreur inattendue", error: e);
      return left(Failure("Impossible de charger les avatars"));
    }
  }
}
