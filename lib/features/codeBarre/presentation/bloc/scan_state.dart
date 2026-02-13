part of 'scan_bloc.dart';

sealed class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

final class ScanInitial extends ScanState {}

final class ScanLoading extends ScanState {}

final class ScanSuccess extends ScanState {
  final AlimentEntity aliment;

  const ScanSuccess(this.aliment);

  @override
  List<Object> get props => [aliment];
}

final class ScanFailure extends ScanState {
  final String message;

  const ScanFailure(this.message);

  @override
  List<Object> get props => [message];
}