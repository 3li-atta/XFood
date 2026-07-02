import 'package:equatable/equatable.dart';

abstract class BackupEvent extends Equatable {
  const BackupEvent();

  @override
  List<Object?> get props => [];
}

class CheckBackupAuth extends BackupEvent {}

class SignInWithGoogle extends BackupEvent {}

class SignOutFromGoogle extends BackupEvent {}

class TriggerBackup extends BackupEvent {}

class LoadBackupHistory extends BackupEvent {}

class TriggerRestore extends BackupEvent {
  final String fileId;
  const TriggerRestore(this.fileId);

  @override
  List<Object?> get props => [fileId];
}
