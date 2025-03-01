
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../routes/app_router.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  String _selectedGender = 'Male';
  String _selectedGoal = 'Weight Loss';
  
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _fitnessGoals = [
    'Weight Loss',
    'Muscle Gain',
    'Improve Fitness',
    'Maintain Weight',
    'Increase Flexibility'
  ];

  int _currentStep = 0;
  final int _totalSteps = 3;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _saveUserDetails() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UserBloc>().add(
        UpdateUserProfile(
          name: _nameController.text,
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
          fitnessGoal: _selectedGoal,
        ),
      );
    }
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _ageController,
          decoration: InputDecoration(
            labelText: 'Age',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            if (int.tryParse(value) == null || int.parse(value) < 12 || int.parse(value) > 100) {
              return 'Please enter a valid age between 12 and 100';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        DropdownButtonFormField<String>(
          value: _selectedGender,
          decoration: InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: _genders.map((gender) {
            return DropdownMenuItem(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGender = value;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildBodyMeasurementsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Body Measurements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _heightController,
          decoration: InputDecoration(
            labelText: 'Height (cm)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your height';
            }
            if (double.tryParse(value) == null || double.parse(value) < 100 || double.parse(value) > 250) {
              return 'Please enter a valid height between 100 and 250 cm';
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        TextFormField(
          controller: _weightController,
          decoration: InputDecoration(
            labelText: 'Weight (kg)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your weight';
            }
            if (double.tryParse(value) == null || double.parse(value) < 30 || double.parse(value) > 250) {
              return 'Please enter a valid weight between 30 and 250 kg';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFitnessGoalsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fitness Goals',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: _selectedGoal,
          decoration: InputDecoration(
            labelText: 'Primary Fitness Goal',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: _fitnessGoals.map((goal) {
            return DropdownMenuItem(
              value: goal,
              child: Text(goal),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedGoal = value;
              });
            }
          },
        ),
        const SizedBox(height: 30),
        const Text(
          'Activity Level:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        _buildActivityLevelSlider(),
      ],
    );
  }

  Widget _buildActivityLevelSlider() {
    return Column(
      children: [
        Slider(
          value: _activityLevel,
          min: 1,
          max: 5,
          divisions: 4,
          label: _getActivityLabel(_activityLevel),
          onChanged: (value) {
            setState(() {
              _activityLevel = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Sedentary', style: TextStyle(fontSize: 12)),
            const Text('Very Active', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          _getActivityDescription(_activityLevel),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  String _getActivityLabel(double value) {
    if (value == 1) return 'Sedentary';
    if (value == 2) return 'Lightly Active';
    if (value == 3) return 'Moderately Active';
    if (value == 4) return 'Very Active';
    if (value == 5) return 'Extremely Active';
    return '';
  }

  String _getActivityDescription(double value) {
    if (value == 1) return 'Little to no exercise';
    if (value == 2) return 'Light exercise 1-3 days/week';
    if (value == 3) return 'Moderate exercise 3-5 days/week';
    if (value == 4) return 'Hard exercise 6-7 days/week';
    if (value == 5) return 'Very hard exercise, physically demanding job';
    return '';
  }

  double _activityLevel = 2;

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPersonalInfoStep();
      case 1:
        return _buildBodyMeasurementsStep();
      case 2:
        return _buildFitnessGoalsStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(_totalSteps, (index) {
        return Expanded(
          child: Container(
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: index <= _currentStep
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Your Profile'),
        elevation: 0,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserProfileUpdated) {
            Navigator.pushReplacementNamed(context, AppRouter.main);
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildStepContent(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep > 0)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _currentStep--;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.black,
                            ),
                            child: const Text('Back'),
                          )
                        else
                          const SizedBox(),
                        ElevatedButton(
                          onPressed: () {
                            if (_currentStep < _totalSteps - 1) {
                              setState(() {
                                _currentStep++;
                              });
                            } else {
                              _saveUserDetails();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            _currentStep < _totalSteps - 1 ? 'Next' : 'Finish',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../routes/app_router.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // User detail fields
  final TextEditingController _nameController = TextEditingController();
  String _selectedGender = 'Male';
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String _selectedGoal = 'Build Muscle';
  String _selectedActivityLevel = 'Moderate';
  
  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _goalOptions = [
    'Build Muscle',
    'Lose Weight',
    'Maintain Weight',
    'Improve Fitness',
    'Increase Strength',
  ];
  final List<String> _activityLevelOptions = [
    'Sedentary',
    'Lightly Active',
    'Moderate',
    'Very Active',
    'Extremely Active',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'We need some information to personalize your experience',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
              ),
              const SizedBox(height: 24),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Gender dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: Icon(Icons.people_outline),
                ),
                items: _genderOptions.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Age field
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Height field
              TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  labelText: 'Height (cm)',
                  prefixIcon: Icon(Icons.height_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Weight field
              TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  prefixIcon: Icon(Icons.line_weight_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              Text(
                'Fitness Goals',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),

              // Fitness goal dropdown
              DropdownButtonFormField<String>(
                value: _selectedGoal,
                decoration: const InputDecoration(
                  labelText: 'Primary Goal',
                  prefixIcon: Icon(Icons.flag_outlined),
                ),
                items: _goalOptions.map((goal) {
                  return DropdownMenuItem<String>(
                    value: goal,
                    child: Text(goal),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGoal = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Activity level dropdown
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                decoration: const InputDecoration(
                  labelText: 'Activity Level',
                  prefixIcon: Icon(Icons.directions_run_outlined),
                ),
                items: _activityLevelOptions.map((level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedActivityLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save user details and continue
                      Navigator.pushReplacementNamed(context, AppRouter.register);
                    }
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
