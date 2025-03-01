
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/datasources/local/app_database.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SharedPreferences sharedPreferences;
  
  SettingsBloc({required this.sharedPreferences}) : super(SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<ToggleNotificationsEvent>(_onToggleNotifications);
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
      final userSettings = await SharedPreferencesHelper.getUserSettings();
      
      if (userSettings != null) {
        emit(SettingsLoaded(settings: userSettings));
      } else {
        // Create default settings if none exist
        final defaultSettings = UserSettings();
        await SharedPreferencesHelper.saveUserSettings(defaultSettings);
        emit(SettingsLoaded(settings: defaultSettings));
      }
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
  
  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      try {
        await SharedPreferencesHelper.saveUserSettings(event.settings);
        emit(SettingsLoaded(settings: event.settings));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
      }
    }
  }
  
  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = UserSettings(
        darkMode: event.isDarkMode,
        pushNotifications: currentState.settings.pushNotifications,
        measurementUnit: currentState.settings.measurementUnit,
        soundEffects: currentState.settings.soundEffects,
        hiddenTabs: currentState.settings.hiddenTabs,
      );
      
      try {
        await SharedPreferencesHelper.saveUserSettings(updatedSettings);
        emit(SettingsLoaded(settings: updatedSettings));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
      }
    }
  }
  
  Future<void> _onToggleNotifications(
    ToggleNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = UserSettings(
        darkMode: currentState.settings.darkMode,
        pushNotifications: event.enableNotifications,
        measurementUnit: currentState.settings.measurementUnit,
        soundEffects: currentState.settings.soundEffects,
        hiddenTabs: currentState.settings.hiddenTabs,
      );
      
      try {
        await SharedPreferencesHelper.saveUserSettings(updatedSettings);
        emit(SettingsLoaded(settings: updatedSettings));
      } catch (e) {
        emit(SettingsError(message: e.toString()));
      }
    }
  }
  
  Future<void> _onChangeMeasurementUnit(
    ChangeMeasurementUnitEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;
      final updatedSettings = UserSettings(
        darkMode: currentState.settings.darkMode,
        pushNotifications: currentState.settings.pushNotifications,
        measurementUnit: event.unit,
        soundEffects: currentState.settings.soundEffects,
        hiddenTabs: currentState.settings.hiddenTabs,
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
      final updatedSettings = UserSettings(
        darkMode: currentState.settings.darkMode,
        pushNotifications: currentState.settings.pushNotifications,
        measurementUnit: currentState.settings.measurementUnit,
        soundEffects: event.enableSoundEffects,
        hiddenTabs: currentState.settings.hiddenTabs,
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
      final defaultSettings = UserSettings();
      await SharedPreferencesHelper.saveUserSettings(defaultSettings);
      emit(SettingsLoaded(settings: defaultSettings));
    } catch (e) {
      emit(SettingsError(message: e.toString()));
    }
  }
}
