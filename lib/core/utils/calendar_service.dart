
import 'dart:io';
import 'package:device_calendar/device_calendar.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/workout.dart';
import '../utils/analytics_service.dart';

class CalendarService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  final AnalyticsService _analyticsService;
  bool _hasPermission = false;
  
  CalendarService(this._analyticsService);
  
  // Request permission to access the device's calendars
  Future<Either<Failure, bool>> requestCalendarPermission() async {
    try {
      final permissionsResult = await _deviceCalendarPlugin.hasPermissions();
      
      if (permissionsResult.isSuccess && permissionsResult.data != true) {
        final requestResult = await _deviceCalendarPlugin.requestPermissions();
        _hasPermission = requestResult.isSuccess && requestResult.data == true;
      } else {
        _hasPermission = permissionsResult.isSuccess && permissionsResult.data == true;
      }
      
      if (_hasPermission) {
        _analyticsService.logEvent(
          name: 'calendar_permission_granted',
          parameters: {
            'platform': Platform.isIOS ? 'iOS' : 'Android',
          },
        );
      } else {
        _analyticsService.logError(
          errorType: 'calendar_permission_denied',
          errorMessage: 'User denied calendar permission',
        );
      }
      
      return Right(_hasPermission);
    } catch (e) {
      _analyticsService.logError(
        errorType: 'calendar_permission_error',
        errorMessage: e.toString(),
      );
      return Left(CalendarFailure('Failed to request calendar permission: ${e.toString()}'));
    }
  }
  
  // Get list of available calendars
  Future<Either<Failure, List<Calendar>>> getCalendars() async {
    try {
      if (!_hasPermission) {
        final permissionResult = await requestCalendarPermission();
        if (permissionResult.isLeft() || 
            (permissionResult.isRight() && permissionResult.getOrElse(() => false) == false)) {
          return Left(CalendarFailure('Calendar permission not granted'));
        }
      }
      
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      
      if (calendarsResult.isSuccess) {
        return Right(calendarsResult.data ?? []);
      } else {
        return Left(CalendarFailure('Failed to retrieve calendars: ${calendarsResult.errorMessages.join(', ')}'));
      }
    } catch (e) {
      _analyticsService.logError(
        errorType: 'get_calendars_error',
        errorMessage: e.toString(),
      );
      return Left(CalendarFailure('Failed to get calendars: ${e.toString()}'));
    }
  }
  
  // Add a workout event to the specified calendar
  Future<Either<Failure, String?>> addWorkoutEvent({
    required String calendarId,
    required Workout workout,
    required DateTime startDate,
    int? reminderMinutes,
    String? description,
  }) async {
    try {
      if (!_hasPermission) {
        final permissionResult = await requestCalendarPermission();
        if (permissionResult.isLeft() || 
            (permissionResult.isRight() && permissionResult.getOrElse(() => false) == false)) {
          return Left(CalendarFailure('Calendar permission not granted'));
        }
      }
      
      final endDate = startDate.add(workout.estimatedDuration);
      
      // Create the event
      final event = Event(
        calendarId,
        title: 'Workout: ${workout.name}',
        description: description ?? 'Fitness workout: ${workout.name}\nDifficulty: ${workout.difficulty}\nType: ${workout.type}',
        start: startDate,
        end: endDate,
      );
      
      // Add reminders if specified
      if (reminderMinutes != null && reminderMinutes > 0) {
        event.reminders = [
          Reminder(minutes: reminderMinutes),
        ];
      }
      
      // Create the event
      final createResult = await _deviceCalendarPlugin.createOrUpdateEvent(event);
      
      if (createResult != null && createResult.isSuccess) {
        // Log the event creation
        _analyticsService.logEvent(
          name: 'workout_added_to_calendar',
          parameters: {
            'workout_id': workout.id,
            'workout_name': workout.name,
            'calendar_id': calendarId,
            'scheduled_date': DateFormat('yyyy-MM-dd HH:mm').format(startDate),
          },
        );
        
        return Right(createResult.data);
      } else {
        return Left(CalendarFailure('Failed to create event: ${createResult?.errorMessages.join(', ') ?? 'Unknown error'}'));
      }
    } catch (e) {
      _analyticsService.logError(
        errorType: 'add_workout_event_error',
        errorMessage: e.toString(),
      );
      return Left(CalendarFailure('Failed to add workout event: ${e.toString()}'));
    }
  }
  
  // Delete a calendar event
  Future<Either<Failure, bool>> deleteEvent({
    required String calendarId,
    required String eventId,
  }) async {
    try {
      if (!_hasPermission) {
        final permissionResult = await requestCalendarPermission();
        if (permissionResult.isLeft() || 
            (permissionResult.isRight() && permissionResult.getOrElse(() => false) == false)) {
          return Left(CalendarFailure('Calendar permission not granted'));
        }
      }
      
      final deleteResult = await _deviceCalendarPlugin.deleteEvent(calendarId, eventId);
      
      if (deleteResult.isSuccess) {
        // Log the event deletion
        _analyticsService.logEvent(
          name: 'workout_removed_from_calendar',
          parameters: {
            'calendar_id': calendarId,
            'event_id': eventId,
          },
        );
        
        return Right(true);
      } else {
        return Left(CalendarFailure('Failed to delete event: ${deleteResult.errorMessages.join(', ')}'));
      }
    } catch (e) {
      _analyticsService.logError(
        errorType: 'delete_event_error',
        errorMessage: e.toString(),
      );
      return Left(CalendarFailure('Failed to delete event: ${e.toString()}'));
    }
  }
  
  // Get events for a specific date range
  Future<Either<Failure, List<Event>>> getEvents({
    required String calendarId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      if (!_hasPermission) {
        final permissionResult = await requestCalendarPermission();
        if (permissionResult.isLeft() || 
            (permissionResult.isRight() && permissionResult.getOrElse(() => false) == false)) {
          return Left(CalendarFailure('Calendar permission not granted'));
        }
      }
      
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        calendarId,
        RetrieveEventsParams(startDate: startDate, endDate: endDate),
      );
      
      if (eventsResult.isSuccess) {
        return Right(eventsResult.data ?? []);
      } else {
        return Left(CalendarFailure('Failed to retrieve events: ${eventsResult.errorMessages.join(', ')}'));
      }
    } catch (e) {
      _analyticsService.logError(
        errorType: 'get_events_error',
        errorMessage: e.toString(),
      );
      return Left(CalendarFailure('Failed to get events: ${e.toString()}'));
    }
  }
}
