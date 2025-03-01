
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/user.dart';
import '../../blocs/user/user_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String? _profileImageUrl;
  String _gender = 'Male';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _bioController = TextEditingController();
    _ageController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
    
    // Load user data when the screen initializes
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      final user = userState.user;
      _nameController.text = user.name;
      _emailController.text = user.email;
      _bioController.text = user.bio ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _heightController.text = user.height?.toString() ?? '';
      _weightController.text = user.weight?.toString() ?? '';
      _profileImageUrl = user.profileImageUrl;
      if (user.gender != null) {
        _gender = user.gender!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoading) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is UserLoaded) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully')),
            );
          } else if (state is UserError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProfileImagePicker(),
                SizedBox(height: SizeConfig.screenHeight! * 0.03),
                _buildPersonalInformationSection(),
                SizedBox(height: SizeConfig.screenHeight! * 0.03),
                _buildFitnessInformationSection(),
                SizedBox(height: SizeConfig.screenHeight! * 0.05),
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Save Changes',
                        onPressed: _saveChanges,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                ? NetworkImage(_profileImageUrl!) as ImageProvider
                : const AssetImage('assets/images/profile_placeholder.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        CustomTextField(
          controller: _nameController,
          label: 'Full Name',
          prefixIcon: Icons.person,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        CustomTextField(
          controller: _emailController,
          label: 'Email',
          prefixIcon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          readOnly: true, // Email usually shouldn't be editable once set
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        CustomTextField(
          controller: _bioController,
          label: 'Bio',
          prefixIcon: Icons.text_snippet,
          maxLines: 3,
          validator: (value) => null, // Optional field
        ),
      ],
    );
  }

  Widget _buildFitnessInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fitness Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _ageController,
                label: 'Age',
                prefixIcon: Icons.cake,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final age = int.tryParse(value);
                    if (age == null || age <= 0 || age > 120) {
                      return 'Invalid age';
                    }
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: SizeConfig.screenWidth! * 0.05),
            Expanded(
              child: _buildGenderDropdown(),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: _heightController,
                label: 'Height (cm)',
                prefixIcon: Icons.height,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final height = double.tryParse(value);
                    if (height == null || height <= 0 || height > 300) {
                      return 'Invalid height';
                    }
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: SizeConfig.screenWidth! * 0.05),
            Expanded(
              child: CustomTextField(
                controller: _weightController,
                label: 'Weight (kg)',
                prefixIcon: Icons.line_weight,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final weight = double.tryParse(value);
                    if (weight == null || weight <= 0 || weight > 500) {
                      return 'Invalid weight';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _gender,
          hint: const Text('Gender'),
          items: ['Male', 'Female', 'Other'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(
                    value == 'Male'
                        ? Icons.male
                        : value == 'Female'
                            ? Icons.female
                            : Icons.person,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _gender = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  void _pickImage() {
    // In a real app, you would use image_picker or another plugin
    // to allow the user to pick an image from gallery or camera
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Profile Picture'),
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

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Create updated user from form data
      final userState = context.read<UserBloc>().state;
      if (userState is UserLoaded) {
        final currentUser = userState.user;
        final updatedUser = User(
          id: currentUser.id,
          name: _nameController.text,
          email: _emailController.text,
          profileImageUrl: _profileImageUrl,
          bio: _bioController.text.isEmpty ? null : _bioController.text,
          gender: _gender,
          age: _ageController.text.isEmpty ? null : int.tryParse(_ageController.text),
          height: _heightController.text.isEmpty ? null : double.tryParse(_heightController.text),
          weight: _weightController.text.isEmpty ? null : double.tryParse(_weightController.text),
        );
        
        // Dispatch update user event to bloc
        context.read<UserBloc>().add(UpdateUserProfileEvent(updatedUser));
      }
    }
  }
}
