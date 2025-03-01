
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/custom_app_bar.dart';

class SaveWorkoutScreen extends StatefulWidget {
  const SaveWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<SaveWorkoutScreen> createState() => _SaveWorkoutScreenState();
}

class _SaveWorkoutScreenState extends State<SaveWorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  double _intensity = 3;
  int _fatigue = 3;
  bool _isUploading = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      // Simulate a network request
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isUploading = false;
        });
        
        // Show success and navigate back to home
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Workout saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Save Workout',
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Workout Summary',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(),
              const SizedBox(height: 24),
              Text(
                'How was your workout?',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildIntensitySelector(),
              const SizedBox(height: 24),
              Text(
                'Fatigue Level',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFatigueSelector(),
              const SizedBox(height: 24),
              Text(
                'Notes',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add notes about your workout...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _saveWorkout,
                  child: _isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Workout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Full Body Workout',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            _buildSummaryRow('Duration', '45:32'),
            const SizedBox(height: 8),
            _buildSummaryRow('Calories Burned', '356'),
            const SizedBox(height: 8),
            _buildSummaryRow('Exercises Completed', '5/5'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Easy'),
            const Text('Moderate'),
            const Text('Intense'),
          ],
        ),
        Slider(
          value: _intensity,
          min: 1,
          max: 5,
          divisions: 4,
          onChanged: (value) {
            setState(() {
              _intensity = value;
            });
          },
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildFatigueSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final level = index + 1;
        return GestureDetector(
          onTap: () {
            setState(() {
              _fatigue = level;
            });
          },
          child: Column(
            children: [
              Icon(
                Icons.sentiment_very_dissatisfied,
                size: 32,
                color: _fatigue == level
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
              const SizedBox(height: 4),
              Text(
                level.toString(),
                style: TextStyle(
                  fontWeight: _fatigue == level ? FontWeight.bold : FontWeight.normal,
                  color: _fatigue == level
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
