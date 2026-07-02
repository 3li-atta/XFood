import 'package:equatable/equatable.dart';
import '../../domain/services/backup_service.dart';

abstract class BackupState extends Equatable {
  const BackupState();

  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {
  final String message;
  const BackupLoading(this.message);

  @override
  List<Object?> get props => [message];
}

class BackupLoaded extends BackupState {
  final bool isAuthenticated;
  final String? email;
  final List<BackupMetadata> backups;

  const BackupLoaded({
    required this.isAuthenticated,
    this.email,
    required this.backups,
  });

  @override
  List<Object?> get props => [isAuthenticated, email, backups];
}

class BackupOperationSuccess extends BackupState {
  final String message;
  final bool shouldRestart;

  const BackupOperationSuccess({required this.message, this.shouldRestart = false});

  @override
  List<Object?> get props => [message, shouldRestart];
}

class BackupFailure extends BackupState {
  final String error;
  const BackupFailure(this.error);

  @override
  List<Object?> get props => [error];
}
