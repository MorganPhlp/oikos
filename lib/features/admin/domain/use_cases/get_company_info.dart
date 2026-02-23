

import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/repositories/company_rep.dart';

class GetCompanyInfo {
  final CompanyRep repository;

  GetCompanyInfo(this.repository);

  Future<Either<Failure, Company>> call(String companyId) {
    return repository.getCompanyData(companyId);
  }
  Future<Either<Failure, void>> updateCompanyInfo(Company company) {
    return repository.updateCompany(company);
  }
}