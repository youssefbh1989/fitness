import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/datasources/local/app_database.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ChangeMeasurementUnitEvent>(_onChangeMeasurementUnit);
    on<ToggleSoundEffectsEvent>(_onToggleSoundEffects);
    on<ResetSettingsEvent>(_onResetSettings);

  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();

      final settings = Settings(
        darkMode: prefs.getBool('darkMode') ?? false,
        notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
        autoSync: prefs.getBool('autoSync') ?? true,
        syncOnWifiOnly: prefs.getBool('syncOnWifiOnly') ?? true,
        syncWorkouts: prefs.getBool('syncWorkouts') ?? true,
        syncNutrition: prefs.getBool('syncNutrition') ?? true,
        syncMeasurements: prefs.getBool('syncMeasurements') ?? true,
        syncFrequency: prefs.getString('syncFrequency') ?? 'Daily',
        pushNotifications: prefs.getBool('pushNotifications') ?? true,
        reminderNotifications: prefs.getBool('reminderNotifications') ?? true,
        achievementNotifications: prefs.getBool('achievementNotifications') ?? true,
        language: prefs.getString('language') ?? 'English',
        measurementUnit: prefs.getString('measurementUnit') ?? 'Metric',
        soundEffects: prefs.getBool('soundEffects') ?? true,
        hiddenTabs: prefs.getStringList('hiddenTabs') ?? [],
      );

      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      emit(SettingsError('Failed to load settings: $e'));
    }
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        darkMode: !currentState.settings.darkMode,
      );

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('darkMode', newSettings.darkMode);

        emit(SettingsLoaded(settings: newSettings));
      } catch (e) {
        emit(SettingsError('Failed to update dark mode setting: $e'));
      }
    }
  }

  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final newSettings = currentState.settings.copyWith(
        notificationsEnabled: !currentState.settings.notificationsEnabled,
      );

      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('notificationsEnabled', newSettings.notificationsEnabled);

        emit(SettingsLoaded(settings: newSettings));
      } catch (e) {
        emit(SettingsError('Failed to update notifications setting: $e'));
      }
    }
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      emit(SettingsLoading());

      final prefs = await SharedPreferences.getInstance();

      // Save all settings
      await prefs.setBool('darkMode', event.settings.darkMode);
      await prefs.setBool('notificationsEnabled', event.settings.notificationsEnabled);
      await prefs.setBool('autoSync', event.settings.autoSync);
      await prefs.setBool('syncOnWifiOnly', event.settings.syncOnWifiOnly);
      await prefs.setBool('syncWorkouts', event.settings.syncWorkouts);
      await prefs.setBool('syncNutrition', event.settings.syncNutrition);
      await prefs.setBool('syncMeasurements', event.settings.syncMeasurements);
      await prefs.setString('syncFrequency', event.settings.syncFrequency);
      await prefs.setBool('pushNotifications', event.settings.pushNotifications);
      await prefs.setBool('reminderNotifications', event.settings.reminderNotifications);
      await prefs.setBool('achievementNotifications', event.settings.achievementNotifications);
      await prefs.setString('language', event.settings.language);
      await prefs.setString('measurementUnit', event.settings.measurementUnit);
      await prefs.setBool('soundEffects', event.settings.soundEffects);
      await prefs.setStringList('hiddenTabs', event.settings.hiddenTabs);


      emit(SettingsLoaded(settings: event.settings));
    } catch (e) {
      emit(SettingsError('Failed to update settings: $e'));
    }
  }
  Future<void> _onChangeMeasurementUnit(
      ChangeMeasurementUnitEvent event,
      Emitter<SettingsState> emit,
      ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        measurementUnit: event.unit,
      );

      try {
        await SharedPreferencesHelper.saveUserSettings(updatedSettings);
        emit(SettingsLoaded(settings: updatedSettings));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
      }
    }
  }

  Future<void> _onToggleSoundEffects(
      ToggleSoundEffectsEvent event,
      Emitter<SettingsState> emit,
      ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = currentState.settings.copyWith(
        soundEffects: event.enableSoundEffects,
      );

      try {
        await SharedPreferencesHelper.saveUserSettings(updatedSettings);
        emit(SettingsLoaded(settings: updatedSettings));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
      }
    }
  }

  Future<void> _onResetSettings(
      ResetSettingsEvent event,
      Emitter<SettingsState> emit,
      ) async {
    emit(SettingsLoading());

    try {
      final defaultSettings = Settings();
      await SharedPreferencesHelper.saveUserSettings(defaultSettings);
      emit(SettingsLoaded(settings: defaultSettings));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}