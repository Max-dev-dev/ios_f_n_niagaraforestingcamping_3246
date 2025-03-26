import 'package:flutter/material.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/main.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/home_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Explore with Purpose",
      "description": [
        "\uD83D\uDD39 Tranquil Retreat — Find peaceful spots to unwind and reconnect with nature.",
        "\uD83D\uDD39 Adventure Camping — Experience the thrill of outdoor camping and hiking.",
        "\uD83D\uDD39 Cultural & Historical Sites — Discover the deep heritage of Kahnawake.",
        "\uD83D\uDD39 Scenic Lookouts — Capture breathtaking views of untouched landscapes.",
      ],
      "buttonText": "Next",
    },
    {
      "title": "Your Journey Starts Here",
      "description": [
        "📍 Interactive Map — Navigate and explore with ease.",
        "⭐ Save Your Favorite Spots — Keep track of places you love.",
        "📖 City Blog & Safety Tips — Learn about the area and stay safe on your trip.",
      ],
      "buttonText": "Next",
    },
    {
      "title": "✨ Ready to Begin?",
      "description": ["Let the forest guide you. 🌲"],
      "buttonText": "Get Started",
    },
    {
      "title": "Attention!",
      "description": [
        "The safety guidelines in Niagara Forest Camping are sourced from official and authoritative sources.",
        "While we strive for accuracy, users should follow local regulations and exercise personal judgment.",
        "The app is not liable for any incidents. Stay safe and explore responsibly.",
      ],
      "buttonText": "I'm Readen",
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/onboard.png', fit: BoxFit.cover),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingData.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: screenWidth > 375 ? 70 : 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2E1D),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: const Color(0xFF101E0F),
                                width: 4,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == onboardingData.length - 1)
                                  Image.asset('assets/images/attention.png'),
                                if (index == onboardingData.length - 1)
                                  const SizedBox(height: 10),
                                Text(
                                  onboardingData[index]['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:
                                      (onboardingData[index]['description']
                                              as List<String>)
                                          .map(
                                            (text) => Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                              ),
                                              child: Text(
                                                text,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                ),
                                const SizedBox(height: 26),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          500,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    onPressed: _nextPage,
                                    child: Text(
                                      onboardingData[index]['buttonText'],
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
