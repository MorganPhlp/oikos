import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/domain/repositories/company_rep.dart';
import 'package:oikos/core/logger.dart';
import 'package:oikos/core/supabase_ext.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyImpl extends CompanyRep {
  final SupabaseClient supabase;

  CompanyImpl(this.supabase);

  @override
  Future<Either<Failure, Company>> getCompanyData(String companyId) async {
    try {
      supabase.logConnection();

      final response = await supabase
          .from('entreprise')
          .select()
          .eq('id', companyId)
          .single();
      return right(Company.fromJson(response));
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }

  @override
  Future<Either<Failure, void>> updateCompany(Company company) async {
    try {
      supabase.logConnection();

      await supabase
          .from('entreprise')
          .update(company.toJson())
          .eq('id', company.id);
      return right(null);
    } on PostgrestException catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Erreur supabase : ${e.message}"));
    } catch (e) {
      logger.e("Erreur Repository", error: e);
      return left(Failure("Une erreur inattendue est survenue"));
    }
  }
}
