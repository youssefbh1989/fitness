
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/workout.dart';
import '../../blocs/workout/workout_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class Exercise {
  final String id;
  final String name;
  final int sets;
  final int reps;
  final String? imageUrl;
  final String? instructions;

  Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    this.imageUrl,
    this.instructions,
  });
}

class CreateWorkoutScreen extends StatefulWidget {
  final Workout? workout; // If editing existing workout, pass it here
  
  const CreateWorkoutScreen({
    Key? key,
    this.workout,
  }) : super(key: key);

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _durationController;
  late TextEditingController _caloriesController;
  String _selectedLevel = 'Beginner';
  String? _imageUrl;
  List<Exercise> _exercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _durationController = TextEditingController();
    _caloriesController = TextEditingController();
    
    // If editing, pre-fill the form with existing data
    if (widget.workout != null) {
      _titleController.text = widget.workout!.title;
      _descriptionController.text = widget.workout!.description;
      _durationController.text = widget.workout!.duration.toString();
      _caloriesController.text = widget.workout!.caloriesBurn.toString();
      _selectedLevel = widget.workout!.level;
      _imageUrl = widget.workout!.imageUrl;
      _exercises = widget.workout!.exercises.map((e) => Exercise(
        id: e.id,
        name: e.name,
        sets: e.sets,
        reps: e.reps,
        imageUrl: e.imageUrl,
        instructions: e.instructions,
      )).toList();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout == null ? 'Create Workout' : 'Edit Workout'),
        elevation: 0,
      ),
      body: BlocListener<WorkoutBloc, WorkoutState>(
        listener: (context, state) {
          if (state is WorkoutLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is WorkoutLoaded) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.workout == null 
                ? 'Workout created successfully' 
                : 'Workout updated successfully')),
            );
            Navigator.pop(context);
          } else if (state is WorkoutError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSelector(),
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      _buildWorkoutDetails(),
                      SizedBox(height: SizeConfig.screenHeight! * 0.03),
                      _buildExercisesList(),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSelector() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: SizeConfig.screenHeight! * 0.2,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          image: _imageUrl != null
              ? DecorationImage(
                  image: NetworkImage(_imageUrl!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: _imageUrl == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.01),
                  Text(
                    'Add Cover Image',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildWorkoutDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Details',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        CustomTextField(
          controller: _titleController,
          label: 'Workout Title',
          prefixIcon: Icons.fitness_center,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        CustomTextField(
          controller: _descriptionController,
          label: 'Description',
          prefixIcon: Icons.description,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _durationController,
                label: 'Duration (min)',
                prefixIcon: Icons.timer,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: SizeConfig.screenWidth! * 0.04),
            Expanded(
              child: CustomTextField(
                controller: _caloriesController,
                label: 'Calories',
                prefixIcon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Invalid';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Text(
          'Difficulty Level',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        _buildLevelSelector(),
      ],
    );
  }

  Widget _buildLevelSelector() {
    return Row(
      children: [
        _buildLevelOption('Beginner'),
        SizedBox(width: SizeConfig.screenWidth! * 0.04),
        _buildLevelOption('Intermediate'),
        SizedBox(width: SizeConfig.screenWidth! * 0.04),
        _buildLevelOption('Advanced'),
      ],
    );
  }

  Widget _buildLevelOption(String level) {
    final isSelected = _selectedLevel == level;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedLevel = level;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            ),
          ),
          child: Center(
            child: Text(
              level,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExercisesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exercises',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addExercise,
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        if (_exercises.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: SizeConfig.screenHeight! * 0.05),
              child: Text(
                'No exercises added yet',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _exercises.length,
            itemBuilder: (context, index) {
              final exercise = _exercises[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${exercise.sets} sets × ${exercise.reps} reps',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () => _editExercise(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () => _removeExercise(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          SizedBox(width: SizeConfig.screenWidth! * 0.04),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    text: widget.workout == null ? 'Create' : 'Update',
                    onPressed: _saveWorkout,
                  ),
          ),
        ],
      ),
    );
  }

  void _pickImage() {
    // In a real app, you would use image_picker or another plugin
    // to allow the user to pick an image from gallery or camera
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Workout Image'),
        content: const Text('This feature is not implemented in this demo.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _addExercise() {
    _showExerciseDialog();
  }

  void _editExercise(int index) {
    _showExerciseDialog(exerciseIndex: index);
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  void _showExerciseDialog({int? exerciseIndex}) {
    final isEditing = exerciseIndex != null;
    final nameController = TextEditingController();
    final setsController = TextEditingController(text: '3');
    final repsController = TextEditingController(text: '12');
    final instructionsController = TextEditingController();
    
    if (isEditing) {
      final exercise = _exercises[exerciseIndex];
      nameController.text = exercise.name;
      setsController.text = exercise.sets.toString();
      repsController.text = exercise.reps.toString();
      if (exercise.instructions != null) {
        instructionsController.text = exercise.instructions!;
      }
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Exercise' : 'Add Exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: nameController,
                label: 'Exercise Name',
                prefixIcon: Icons.fitness_center,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: setsController,
                      label: 'Sets',
                      prefixIcon: Icons.repeat,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: repsController,
                      label: 'Reps',
                      prefixIcon: Icons.fitness_center,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        if (int.tryParse(value) == null || int.parse(value) <= 0) {
                          return 'Invalid';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: instructionsController,
                label: 'Instructions (Optional)',
                prefixIcon: Icons.info,
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isEmpty || 
                  setsController.text.isEmpty || 
                  repsController.text.isEmpty) {
                return;
              }
              
              final exercise = Exercise(
                id: isEditing ? _exercises[exerciseIndex].id : DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                sets: int.parse(setsController.text),
                reps: int.parse(repsController.text),
                instructions: instructionsController.text.isEmpty ? null : instructionsController.text,
              );
              
              setState(() {
                if (isEditing) {
                  _exercises[exerciseIndex] = exercise;
                } else {
                  _exercises.add(exercise);
                }
              });
              
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      if (_exercises.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one exercise')),
        );
        return;
      }
      
      // Create workout object from form data
      final workoutExercises = _exercises.map((e) => WorkoutExercise(
        id: e.id,
        name: e.name,
        sets: e.sets,
        reps: e.reps,
        imageUrl: e.imageUrl,
        instructions: e.instructions,
      )).toList();
      
      final workout = Workout(
        id: widget.workout?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrl ?? 'assets/images/workout_placeholder.jpg',
        duration: int.parse(_durationController.text),
        caloriesBurn: int.parse(_caloriesController.text),
        level: _selectedLevel,
        exercises: workoutExercises,
        isFavorite: widget.workout?.isFavorite ?? false,
      );
      
      // Dispatch create/update workout event to bloc
      if (widget.workout == null) {
        context.read<WorkoutBloc>().add(CreateWorkoutEvent(workout));
      } else {
        context.read<WorkoutBloc>().add(UpdateWorkoutEvent(workout));
      }
    }
  }
}
