
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../../domain/entities/workout.dart';
import '../../../domain/entities/exercise_set.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/entities/achievement.dart';
import '../../../domain/entities/nutrition.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _database;

  factory AppDatabase() {
    return _instance;
  }

  AppDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fitness_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        profileImageUrl TEXT,
        height REAL,
        weight REAL,
        dateOfBirth TEXT,
        gender TEXT
      )
    ''');

    // Workouts table
    await db.execute('''
      CREATE TABLE workouts(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        difficulty TEXT,
        duration INTEGER,
        category TEXT,
        isCustom INTEGER
      )
    ''');

    // Exercises table
    await db.execute('''
      CREATE TABLE exercises(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        videoUrl TEXT,
        category TEXT,
        equipment TEXT
      )
    ''');

    // Workout_Exercise join table
    await db.execute('''
      CREATE TABLE workout_exercises(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutId TEXT NOT NULL,
        exerciseId TEXT NOT NULL,
        order_index INTEGER NOT NULL,
        sets INTEGER,
        reps INTEGER,
        weight REAL,
        duration INTEGER,
        FOREIGN KEY (workoutId) REFERENCES workouts (id),
        FOREIGN KEY (exerciseId) REFERENCES exercises (id)
      )
    ''');

    // Completed workouts table
    await db.execute('''
      CREATE TABLE completed_workouts(
        id TEXT PRIMARY KEY,
        workoutId TEXT NOT NULL,
        userId TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        calories INTEGER,
        FOREIGN KEY (workoutId) REFERENCES workouts (id),
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Completed sets table
    await db.execute('''
      CREATE TABLE completed_sets(
        id TEXT PRIMARY KEY,
        completedWorkoutId TEXT NOT NULL,
        exerciseId TEXT NOT NULL,
        sets INTEGER,
        reps INTEGER,
        weight REAL,
        duration INTEGER,
        FOREIGN KEY (completedWorkoutId) REFERENCES completed_workouts (id),
        FOREIGN KEY (exerciseId) REFERENCES exercises (id)
      )
    ''');

    // Achievements table
    await db.execute('''
      CREATE TABLE achievements(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        imageUrl TEXT,
        criteria TEXT,
        xpPoints INTEGER
      )
    ''');

    // User achievements table
    await db.execute('''
      CREATE TABLE user_achievements(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        achievementId TEXT NOT NULL,
        dateEarned TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (achievementId) REFERENCES achievements (id)
      )
    ''');

    // Nutrition items table
    await db.execute('''
      CREATE TABLE nutrition_items(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        calories INTEGER,
        protein REAL,
        carbs REAL,
        fat REAL,
        servingSize TEXT,
        category TEXT,
        imageUrl TEXT
      )
    ''');

    // User meals table
    await db.execute('''
      CREATE TABLE user_meals(
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        name TEXT,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Meal items table
    await db.execute('''
      CREATE TABLE meal_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mealId TEXT NOT NULL,
        nutritionItemId TEXT NOT NULL,
        servings REAL NOT NULL,
        FOREIGN KEY (mealId) REFERENCES user_meals (id),
        FOREIGN KEY (nutritionItemId) REFERENCES nutrition_items (id)
      )
    ''');
  }

  // USER OPERATIONS
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // WORKOUT OPERATIONS
  Future<int> insertWorkout(Workout workout) async {
    final db = await database;
    final batch = db.batch();
    
    // Insert workout
    batch.insert('workouts', workout.toMap());
    
    // Insert exercises and workout_exercises
    for (var i = 0; i < workout.exercises.length; i++) {
      final exercise = workout.exercises[i];
      batch.insert('exercises', exercise.toMap(), conflictAlgorithm: ConflictAlgorithm.ignore);
      batch.insert('workout_exercises', {
        'workoutId': workout.id,
        'exerciseId': exercise.id,
        'order_index': i,
        'sets': exercise.defaultSets,
        'reps': exercise.defaultReps,
        'weight': exercise.defaultWeight,
        'duration': exercise.defaultDuration,
      });
    }
    
    await batch.commit(noResult: true);
    return 1;
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await database;
    final workoutMaps = await db.query('workouts');
    
    if (workoutMaps.isEmpty) {
      return [];
    }
    
    List<Workout> workouts = [];
    
    for (var workoutMap in workoutMaps) {
      final workoutId = workoutMap['id'] as String;
      
      // Get all workout exercises with join
      final exercises = await db.rawQuery('''
        SELECT e.*, we.sets, we.reps, we.weight, we.duration, we.order_index
        FROM exercises e
        JOIN workout_exercises we ON e.id = we.exerciseId
        WHERE we.workoutId = ?
        ORDER BY we.order_index
      ''', [workoutId]);
      
      final workout = Workout.fromMap(workoutMap, exercises.map((e) => Exercise.fromMap(e)).toList());
      workouts.add(workout);
    }
    
    return workouts;
  }

  // COMPLETED WORKOUT OPERATIONS
  Future<int> insertCompletedWorkout(
    String workoutId,
    String userId,
    DateTime startTime,
    DateTime endTime,
    List<ExerciseSet> completedSets,
    int calories,
  ) async {
    final db = await database;
    final completedWorkoutId = DateTime.now().millisecondsSinceEpoch.toString();
    final batch = db.batch();
    
    batch.insert('completed_workouts', {
      'id': completedWorkoutId,
      'workoutId': workoutId,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'calories': calories,
    });
    
    for (var set in completedSets) {
      batch.insert('completed_sets', {
        'id': set.id,
        'completedWorkoutId': completedWorkoutId,
        'exerciseId': set.exerciseId,
        'sets': set.sets,
        'reps': set.reps,
        'weight': set.weight,
        'duration': set.duration,
      });
    }
    
    await batch.commit(noResult: true);
    return 1;
  }

  // ACHIEVEMENT OPERATIONS
  Future<List<Achievement>> getAchievements() async {
    final db = await database;
    final maps = await db.query('achievements');
    return maps.map((map) => Achievement.fromMap(map)).toList();
  }
  
  Future<List<Achievement>> getUserAchievements(String userId) async {
    final db = await database;
    final maps = await db.rawQuery('''
      SELECT a.*, ua.dateEarned
      FROM achievements a
      JOIN user_achievements ua ON a.id = ua.achievementId
      WHERE ua.userId = ?
    ''', [userId]);
    return maps.map((map) => Achievement.fromMap(map)).toList();
  }

  Future<int> addUserAchievement(String userId, String achievementId, DateTime dateEarned) async {
    final db = await database;
    return await db.insert('user_achievements', {
      'userId': userId,
      'achievementId': achievementId,
      'dateEarned': dateEarned.toIso8601String(),
    });
  }

  // NUTRITION OPERATIONS
  Future<List<NutritionItem>> getNutritionItems() async {
    final db = await database;
    final maps = await db.query('nutrition_items');
    return maps.map((map) => NutritionItem.fromMap(map)).toList();
  }
}

// SharedPreferences Helper for lightweight storage
class SharedPreferencesHelper {
  static Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_settings', jsonEncode(settings.toMap()));
  }
  
  static Future<UserSettings?> getUserSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('user_settings');
    if (settingsJson != null) {
      return UserSettings.fromMap(jsonDecode(settingsJson));
    }
    return null;
  }
  
  static Future<void> setFirstTimeLaunch(bool isFirstTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_time', isFirstTime);
  }
  
  static Future<bool> isFirstTimeLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_first_time') ?? true;
  }
  
  static Future<void> setLoggedInUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_user_id', userId);
  }
  
  static Future<String?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_in_user_id');
  }
  
  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user_id');
  }
}

class UserSettings {
  final bool darkMode;
  final bool pushNotifications;
  final String measurementUnit;
  final bool soundEffects;
  final List<String> hiddenTabs;

  UserSettings({
    this.darkMode = false,
    this.pushNotifications = true,
    this.measurementUnit = 'metric',
    this.soundEffects = true,
    this.hiddenTabs = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'darkMode': darkMode,
      'pushNotifications': pushNotifications,
      'measurementUnit': measurementUnit,
      'soundEffects': soundEffects,
      'hiddenTabs': hiddenTabs,
    };
  }

  factory UserSettings.fromMap(Map<String, dynamic> map) {
    return UserSettings(
      darkMode: map['darkMode'] ?? false,
      pushNotifications: map['pushNotifications'] ?? true,
      measurementUnit: map['measurementUnit'] ?? 'metric',
      soundEffects: map['soundEffects'] ?? true,
      hiddenTabs: List<String>.from(map['hiddenTabs'] ?? []),
    );
  }
}
