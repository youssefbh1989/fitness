import 'package:equatable/equatable.dart';

class Settings extends Equatable {
  final bool darkMode;
  final bool notificationsEnabled;
  final bool autoSync;
  final bool syncOnWifiOnly;
  final bool syncWorkouts;
  final bool syncNutrition;
  final bool syncMeasurements;
  final String syncFrequency;
  final bool pushNotifications;
  final bool reminderNotifications;
  final bool achievementNotifications;
  final String language;

  const Settings({
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.autoSync = true,
    this.syncOnWifiOnly = true,
    this.syncWorkouts = true,
    this.syncNutrition = true,
    this.syncMeasurements = true,
    this.syncFrequency = 'Daily',
    this.pushNotifications = true,
    this.reminderNotifications = true,
    this.achievementNotifications = true,
    this.language = 'English',
  });

  Settings copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    bool? autoSync,
    bool? syncOnWifiOnly,
    bool? syncWorkouts,
    bool? syncNutrition,
    bool? syncMeasurements,
    String? syncFrequency,
    bool? pushNotifications,
    bool? reminderNotifications,
    bool? achievementNotifications,
    String? language,
  }) {
    return Settings(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoSync: autoSync ?? this.autoSync,
      syncOnWifiOnly: syncOnWifiOnly ?? this.syncOnWifiOnly,
      syncWorkouts: syncWorkouts ?? this.syncWorkouts,
      syncNutrition: syncNutrition ?? this.syncNutrition,
      syncMeasurements: syncMeasurements ?? this.syncMeasurements,
      syncFrequency: syncFrequency ?? this.syncFrequency,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      reminderNotifications: reminderNotifications ?? this.reminderNotifications,
      achievementNotifications: achievementNotifications ?? this.achievementNotifications,
      language: language ?? this.language,
    );
  }

  @override
  List<Object> get props => [
        darkMode,
        notificationsEnabled,
        autoSync,
        syncOnWifiOnly,
        syncWorkouts,
        syncNutrition,
        syncMeasurements,
        syncFrequency,
        pushNotifications,
        reminderNotifications,
        achievementNotifications,
        language,
      ];
}

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}