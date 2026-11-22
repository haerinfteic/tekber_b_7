import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/landing_campus_info.dart';
import '../widgets/landing_feature_cards.dart';
import '../widgets/landing_footer.dart';
import '../widgets/landing_hero_search.dart';
import '../widgets/landing_navbar.dart';
import '../widgets/landing_popular_sports.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LandingNavbar(),
              LandingHeroSearch(),
              LandingFeatureCards(),
              LandingPopularSports(),
              LandingCampusInfo(),
              LandingFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
