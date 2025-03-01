
part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final UserSettings settings;
  
  const UpdateSettingsEvent({required this.settings});
  
  @override
  List<Object> get props => [settings];
}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool isDarkMode;
  
  const ToggleDarkModeEvent({required this.isDarkMode});
  
  @override
  List<Object> get props => [isDarkMode];
}

class ToggleNotificationsEvent extends SettingsEvent {
  final bool enableNotifications;
  
  const ToggleNotificationsEvent({required this.enableNotifications});
  
  @override
  List<Object> get props => [enableNotifications];
}

class ChangeMeasurementUnitEvent extends SettingsEvent {
  final String unit; // 'metric' or 'imperial'
  
  const ChangeMeasurementUnitEvent({required this.unit});
  
  @override
  List<Object> get props => [unit];
}

class ToggleSoundEffectsEvent extends SettingsEvent {
  final bool enableSoundEffects;
  
  const ToggleSoundEffectsEvent({required this.enableSoundEffects});
  
  @override
  List<Object> get props => [enableSoundEffects];
}

class ResetSettingsEvent extends SettingsEvent {}
