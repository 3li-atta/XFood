import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/services/backup_service.dart';
import 'backup_event.dart';
import 'backup_state.dart';

class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupService _backupService;

  BackupBloc(this._backupService) : super(BackupInitial()) {
    on<CheckBackupAuth>(_onCheckBackupAuth);
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOutFromGoogle>(_onSignOutFromGoogle);
    on<LoadBackupHistory>(_onLoadBackupHistory);
    on<TriggerBackup>(_onTriggerBackup);
    on<TriggerRestore>(_onTriggerRestore);
  }

  Future<void> _onCheckBackupAuth(CheckBackupAuth event, Emitter<BackupState> emit) async {
    final isAuthenticated = await _backupService.isClientAuthenticated;
    if (isAuthenticated) {
      final email = await _backupService.currentUserEmail;
      emit(BackupLoaded(
        isAuthenticated: true,
        email: email,
        backups: const [],
      ));
      add(LoadBackupHistory());
    } else {
      emit(const BackupLoaded(
        isAuthenticated: false,
        backups: [],
      ));
    }
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogle event, Emitter<BackupState> emit) async {
    emit(const BackupLoading('جاري تسجيل الدخول باستخدام Google...'));
    try {
      final success = await _backupService.authenticate();
      if (success) {
        final email = await _backupService.currentUserEmail;
        emit(BackupLoaded(
          isAuthenticated: true,
          email: email,
          backups: const [],
        ));
        add(LoadBackupHistory());
      } else {
        emit(const BackupFailure('فشل تسجيل الدخول أو تم إلغاؤه.'));
        add(CheckBackupAuth());
      }
    } on PlatformException catch (e) {
      emit(BackupFailure('PlatformException error: [${e.code}] ${e.message}'));
      add(CheckBackupAuth());
    } catch (e) {
      emit(BackupFailure('Unexpected error: ${e.toString()}'));
      add(CheckBackupAuth());
    }
  }

  Future<void> _onSignOutFromGoogle(SignOutFromGoogle event, Emitter<BackupState> emit) async {
    emit(const BackupLoading('جاري تسجيل الخروج...'));
    await _backupService.signOut();
    emit(const BackupLoaded(
      isAuthenticated: false,
      backups: [],
    ));
  }

  Future<void> _onLoadBackupHistory(LoadBackupHistory event, Emitter<BackupState> emit) async {
    final currentState = state;
    if (currentState is BackupLoaded) {
      final backups = await _backupService.listBackups();
      emit(BackupLoaded(
        isAuthenticated: currentState.isAuthenticated,
        email: currentState.email,
        backups: backups,
      ));
    }
  }

  Future<void> _onTriggerBackup(TriggerBackup event, Emitter<BackupState> emit) async {
    final currentState = state;
    if (currentState is BackupLoaded && currentState.isAuthenticated) {
      emit(const BackupLoading('جاري إنشاء نسخة احتياطية على Google Drive...'));
      try {
        final fileId = await _backupService.backupDatabase();
        if (fileId != null) {
          emit(const BackupOperationSuccess(message: 'تم إنشاء النسخة الاحتياطية بنجاح!'));
        } else {
          emit(const BackupFailure('فشل رفع النسخة الاحتياطية لقاعدة البيانات.'));
        }
      } on PlatformException catch (e) {
        emit(BackupFailure('PlatformException error: [${e.code}] ${e.message}'));
      } catch (e) {
        emit(BackupFailure('Unexpected error: ${e.toString()}'));
      }
      add(CheckBackupAuth());
    }
  }

  Future<void> _onTriggerRestore(TriggerRestore event, Emitter<BackupState> emit) async {
    final currentState = state;
    if (currentState is BackupLoaded && currentState.isAuthenticated) {
      emit(const BackupLoading('جاري تحميل واستعادة قاعدة البيانات...'));
      try {
        final success = await _backupService.restoreDatabase(event.fileId);
        if (success) {
          emit(const BackupOperationSuccess(
            message: 'تم استعادة قاعدة البيانات بنجاح! سيتم إعادة تشغيل التطبيق الآن لتطبيق التغييرات.',
            shouldRestart: true,
          ));
        } else {
          emit(const BackupFailure('فشل استعادة قاعدة البيانات من النسخة الاحتياطية.'));
          add(CheckBackupAuth());
        }
      } on PlatformException catch (e) {
        emit(BackupFailure('PlatformException error: [${e.code}] ${e.message}'));
        add(CheckBackupAuth());
      } catch (e) {
        emit(BackupFailure('Unexpected error: ${e.toString()}'));
        add(CheckBackupAuth());
      }
    }
  }
}
