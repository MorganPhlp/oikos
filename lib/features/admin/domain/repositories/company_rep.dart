

import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/models.dart';

abstract class CompanyRep {
  Future<Either<Failure, Company>> getCompanyData(String companyId);
  Future<Either<Failure, void>> updateCompany(Company company);
}