

import 'package:fpdart/fpdart.dart';
import 'package:oikos/core/error/failures.dart';
import 'package:oikos/features/admin/data/models/models.dart';
import 'package:oikos/features/admin/domain/interfaces/company_rep.dart';

class UpdateCompany {
  final CompanyRep repository;

  UpdateCompany(this.repository);

  Future<Either<Failure, void>> call(Company company) {
    return repository.updateCompany(company);
  }
}