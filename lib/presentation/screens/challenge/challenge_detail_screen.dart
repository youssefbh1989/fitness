
import 'package:flutter/material.dart';
import '../../../core/utils/size_config.dart';
import '../../widgets/custom_button.dart';

class Challenge {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int duration; // in days
  final int participants;
  final bool joined;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.participants,
    this.joined = false,
  });
}

class ChallengeDetailScreen extends StatefulWidget {
  final Challenge challenge;

  const ChallengeDetailScreen({
    Key? key,
    required this.challenge,
  }) : super(key: key);

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late bool _isJoined;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.challenge.joined;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.screenWidth! * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildChallengeInfo(context),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  _buildChallengeDescription(context),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  _buildParticipants(context),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  _buildRules(context),
                  SizedBox(height: SizeConfig.screenHeight! * 0.03),
                  _buildRewards(context),
                  SizedBox(height: SizeConfig.screenHeight! * 0.05),
                  CustomButton(
                    text: _isJoined ? 'Leave Challenge' : 'Join Challenge',
                    onPressed: () {
                      setState(() {
                        _isJoined = !_isJoined;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_isJoined 
                          ? 'You joined ${widget.challenge.title}' 
                          : 'You left ${widget.challenge.title}'))
                      );
                    },
                    color: _isJoined ? Colors.red : Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: SizeConfig.screenHeight! * 0.3,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.challenge.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Hero(
          tag: 'challenge_image_${widget.challenge.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.challenge.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/challenge_placeholder.jpg',
                    fit: BoxFit.cover,
                  );
                },
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Sharing challenge...'))
            );
          },
        ),
      ],
    );
  }

  Widget _buildChallengeInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(
          context, 
          Icons.calendar_today,
          '${widget.challenge.duration} days',
          'Duration'
        ),
        _buildInfoItem(
          context, 
          Icons.people,
          '${widget.challenge.participants}',
          'Participants'
        ),
        _buildInfoItem(
          context, 
          Icons.emoji_events,
          'Badges',
          'Rewards'
        ),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildChallengeDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.01),
        Text(
          widget.challenge.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildParticipants(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Participants',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10, // Just showing 10 example participants
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        'assets/images/profile_placeholder.png',
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'User ${index + 1}',
                      style: const TextStyle(fontSize: 12),
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

  Widget _buildRules(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Challenge Rules',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        _buildRuleItem(context, 'Complete the workout every day'),
        _buildRuleItem(context, 'Share your progress to earn extra points'),
        _buildRuleItem(context, 'Support other participants'),
        _buildRuleItem(context, 'Track your results in the app'),
      ],
    );
  }

  Widget _buildRuleItem(BuildContext context, String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(rule),
          ),
        ],
      ),
    );
  }

  Widget _buildRewards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rewards',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: SizeConfig.screenHeight! * 0.02),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildRewardItem(context, Icons.emoji_events, 'Gold Badge', 'Win the challenge'),
            _buildRewardItem(context, Icons.fitness_center, 'Health Points', 'Complete daily'),
            _buildRewardItem(context, Icons.star, 'Achievement', 'Special profile achievement'),
          ],
        ),
      ],
    );
  }

  Widget _buildRewardItem(BuildContext context, IconData icon, String title, String description) {
    return Container(
      width: SizeConfig.screenWidth! * 0.25,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 3),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
