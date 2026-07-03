# Flutter Proguard Rules

# Workmanager configuration to prevent background task dispatcher stripping
-keep class com.dexterous.flutterworkmanager.** { *; }

# Drift / SQLite native library rules
-keep class org.sqlite.** { *; }
-keep class net.sqlcipher.** { *; }
-dontwarn org.sqlite.**
-dontwarn net.sqlcipher.**

# Bcrypt rules
-keep class org.mindrot.jbcrypt.** { *; }

# Keep Flutter/Dart entrypoints
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.** { *; }

# Keep generated code for dependency injection (GetIt) and Drift
-keep class **.Companion { *; }
-keep class * extends drift.GeneratedDatabase { *; }
-keep class * extends drift.Table { *; }
-keep class * extends drift.Dao { *; }

# Ignore Google Play Core deferred components missing warnings
-dontwarn com.google.android.play.core.**

