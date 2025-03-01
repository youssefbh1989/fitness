import 'package:equatable/equatable.dart';
import 'settings_state.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {}

class ToggleDarkModeEvent extends SettingsEvent {}

class ToggleNotificationsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final Settings settings;

  const UpdateSettingsEvent({
    required this.settings,
  });

  @override
  List<Object> get props => [settings];
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

class ExportDataEvent extends SettingsEvent {}

class ImportDataEvent extends SettingsEvent {}


class UpdateBodyMeasurementsEvent extends SettingsEvent {
  final Map<String, double> measurements;

  const UpdateBodyMeasurementsEvent({required this.measurements});

  @override
  List<Object> get props => [measurements];
}