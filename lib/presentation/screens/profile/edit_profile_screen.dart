
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';
import '../../widgets/custom_app_bar.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late String _selectedGender;
  late String _selectedGoal;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    _selectedGender = 'Male';
    _selectedGoal = 'Weight Loss';
    
    // Initialize with current user data
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _populateUserData(userState.user);
    }
  }

  void _populateUserData(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _ageController.text = user.age.toString();
    _heightController.text = user.height.toString();
    _weightController.text = user.weight.toString();
    _selectedGender = user.gender;
    _selectedGoal = user.fitnessGoal;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Edit Profile',
        showBackButton: true,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
            Navigator.pop(context);
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(SizeConfig.defaultPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: () {
                                // Implement image upload functionality
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.mediumPadding),
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Gender dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.people),
                    ),
                    items: ['Male', 'Female', 'Other']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGender = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  Text(
                    'Physical Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Age field
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      prefixIcon: Icon(Icons.cake),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Height field
                  TextFormField(
                    controller: _heightController,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      prefixIcon: Icon(Icons.height),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your height';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Weight field
                  TextFormField(
                    controller: _weightController,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      prefixIcon: Icon(Icons.monitor_weight),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your weight';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  Text(
                    'Fitness Goals',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                  
                  // Fitness goal dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedGoal,
                    decoration: InputDecoration(
                      labelText: 'Primary Goal',
                      prefixIcon: Icon(Icons.flag),
                    ),
                    items: ['Weight Loss', 'Muscle Gain', 'Improve Fitness', 'Maintain Weight']
                        .map((goal) => DropdownMenuItem(
                              value: goal,
                              child: Text(goal),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedGoal = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: SizeConfig.largePadding),
                  
                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text('Save Changes'),
                    ),
                  ),
                  SizedBox(height: SizeConfig.defaultPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Create updated user object
      final updatedUser = User(
        id: 'current-user-id', // This should be retrieved from the current user
        name: _nameController.text,
        email: _emailController.text,
        age: int.parse(_ageController.text),
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        gender: _selectedGender,
        fitnessGoal: _selectedGoal,
        profilePicture: 'assets/images/avatar.png', // This should be updated if user uploads a new image
      );
      
      // Dispatch update event
      context.read<UserBloc>().add(UpdateUserProfileEvent(updatedUser));
    }
  }
}
