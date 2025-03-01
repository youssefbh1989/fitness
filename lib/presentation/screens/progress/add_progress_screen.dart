
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/size_config.dart';
import '../../../domain/entities/progress.dart';
import '../../blocs/progress/progress_bloc.dart';
import '../../widgets/custom_app_bar.dart';

class AddProgressScreen extends StatefulWidget {
  final String userId;
  
  const AddProgressScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<AddProgressScreen> createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _bodyFatController = TextEditingController();
  final _muscleMassController = TextEditingController();
  
  @override
  void dispose() {
    _weightController.dispose();
    _bodyFatController.dispose();
    _muscleMassController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              title: 'Add Progress Entry',
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(SizeConfig.defaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Progress',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: SizeConfig.mediumPadding),
                      
                      // Weight field
                      Text(
                        'Weight (kg)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: SizeConfig.smallPadding),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your weight',
                          suffixText: 'kg',
                        ),
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
                      SizedBox(height: SizeConfig.mediumPadding),
                      
                      // Body fat field
                      Text(
                        'Body Fat % (optional)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: SizeConfig.smallPadding),
                      TextFormField(
                        controller: _bodyFatController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your body fat percentage',
                          suffixText: '%',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final bodyFat = double.tryParse(value);
                            if (bodyFat == null) {
                              return 'Please enter a valid number';
                            }
                            if (bodyFat < 0 || bodyFat > 100) {
                              return 'Body fat should be between 0 and 100';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SizeConfig.mediumPadding),
                      
                      // Muscle mass field
                      Text(
                        'Muscle Mass (optional)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: SizeConfig.smallPadding),
                      TextFormField(
                        controller: _muscleMassController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter your muscle mass',
                          suffixText: 'kg',
                        ),
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SizeConfig.largePadding),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Save Progress'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final weight = double.parse(_weightController.text);
      final bodyFat = _bodyFatController.text.isNotEmpty 
          ? double.parse(_bodyFatController.text) 
          : null;
      final muscleMass = _muscleMassController.text.isNotEmpty 
          ? double.parse(_muscleMassController.text) 
          : null;
          
      final progress = Progress(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: widget.userId,
        date: DateTime.now(),
        weight: weight,
        bodyFat: bodyFat,
        muscleMass: muscleMass,
      );
      
      context.read<ProgressBloc>().add(AddNewProgressEntry(progress: progress));
      Navigator.pop(context);
    }
  }
}
