import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/features/admin/domain/repositories/logos_rep.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogosImpl extends LogosRep {
  final SupabaseClient supabase;

  LogosImpl(this.supabase);
  @override
  Future<Either<Failure, List<String>>> getLogos() async {
    try {
      // 1. Lister tous les fichiers dans le bucket 'logos'
      final List<FileObject> objects = await supabase.storage
          .from('logos')
          .list();
      

      // 2. Transformer la liste d'objets en liste d'URLs publiques
      final List<String> urls = objects
          .where(
            (file) => !file.name.startsWith('.'),
          ) // Exclure les fichiers cachés
          .map((file) {
            return supabase.storage.from('logos').getPublicUrl(file.name);
          })
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
      

      // 2. Transformer la liste d'objets en liste d'URLs publiques
      final List<String> urls = objects
          .where(
            (file) => !file.name.startsWith('.'),
          ) // Exclure les fichiers cachés
          .map((file) {
            return supabase.storage.from('avatars').getPublicUrl(file.name);
          })
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
