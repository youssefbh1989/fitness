
import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _selectedPlanIndex = 1; // Default to monthly plan
  
  final List<Map<String, dynamic>> _plans = [
    {
      'title': 'Monthly',
      'price': 9.99,
      'description': 'Pay monthly, cancel anytime',
      'discount': null,
    },
    {
      'title': 'Yearly',
      'price': 79.99,
      'description': 'Save 33% compared to monthly',
      'discount': '33% OFF',
    },
    {
      'title': 'Lifetime',
      'price': 199.99,
      'description': 'One-time payment, lifetime access',
      'discount': 'BEST VALUE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Membership'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    SizedBox(height: SizeConfig.screenHeight! * 0.03),
                    _buildFeaturesList(),
                    SizedBox(height: SizeConfig.screenHeight! * 0.03),
                    _buildPlanSelection(),
                    SizedBox(height: SizeConfig.screenHeight! * 0.03),
                    _buildTestimonials(),
                    SizedBox(height: SizeConfig.screenHeight! * 0.03),
                    _buildFAQ(),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.star,
            color: Colors.white,
            size: 60,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Unlock Premium Features',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Take your fitness journey to the next level',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      {
        'icon': Icons.fitness_center,
        'title': 'Unlimited Workouts',
        'description': 'Access to premium workout plans',
      },
      {
        'icon': Icons.show_chart,
        'title': 'Advanced Analytics',
        'description': 'Detailed progress tracking and insights',
      },
      {
        'icon': Icons.person,
        'title': 'Personal Coach',
        'description': 'AI coach to guide your training',
      },
      {
        'icon': Icons.restaurant_menu,
        'title': 'Nutrition Plans',
        'description': 'Customized meal plans and recipes',
      },
      {
        'icon': Icons.notifications_none,
        'title': 'No Ads',
        'description': 'Ad-free experience throughout the app',
      },
    ];

    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      feature['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlanSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_plans.length, (index) {
          final plan = _plans[index];
          final isSelected = _selectedPlanIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlanIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                  width: 2,
                ),
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plan['title'] as String,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (plan['discount'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  plan['discount'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          plan['description'] as String,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${plan['price']}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '7-day free trial ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'available with all plans.\nCancel anytime before the trial ends.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestimonials() {
    final testimonials = [
      {
        'name': 'Sarah K.',
        'comment': 'The premium features helped me lose 15 pounds in 3 months!',
        'imagePath': 'assets/images/profile_placeholder.png',
      },
      {
        'name': 'Michael R.',
        'comment': 'The personalized meal plans changed my relationship with food completely.',
        'imagePath': 'assets/images/profile_placeholder.png',
      },
      {
        'name': 'Jessica T.',
        'comment': 'With the AI coach, I finally achieved my fitness goals. Worth every penny!',
        'imagePath': 'assets/images/profile_placeholder.png',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What Our Members Say',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: testimonials.length,
            itemBuilder: (context, index) {
              final testimonial = testimonials[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(testimonial['imagePath'] as String),
                          radius: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          testimonial['name'] as String,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        testimonial['comment'] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFAQ() {
    final faqs = [
      {
        'question': 'Can I cancel my subscription?',
        'answer': 'Yes, you can cancel your subscription at any time. If you cancel during your free trial period, you won\'t be charged.',
      },
      {
        'question': 'Will I lose my data if I cancel?',
        'answer': 'No, your workout history and achievements will be saved. However, you\'ll lose access to premium features.',
      },
      {
        'question': 'Can I switch plans later?',
        'answer': 'Yes, you can upgrade or downgrade your plan at any time. The new pricing will be applied to your next billing cycle.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Frequently Asked Questions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...faqs.map((faq) {
          return ExpansionTile(
            title: Text(
              faq['question'] as String,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(faq['answer'] as String),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Initiate payment process
                _showProcessingDialog();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'START FREE TRIAL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Secure payment powered by Stripe',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'By continuing, you agree to our ',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const TextSpan(
                  text: ' and ',
                ),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Processing your request...'),
          ],
        ),
      ),
    );
    
    // Simulate processing delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close processing dialog
      
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Trial Started!'),
          content: const Text(
            'Your 7-day free trial has started. Enjoy premium features!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close success dialog
                Navigator.pop(context); // Return to previous screen
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      );
    });
  }
}
