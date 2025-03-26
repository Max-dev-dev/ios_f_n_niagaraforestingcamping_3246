import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SafetyArticle> articles = [
      SafetyArticle(
        title: "Wildfire Safety During Outdoor Recreation",
        content:
            "Wildfires pose significant threats to Canada's forests and communities. To minimize the risk of human-caused wildfires, it's essential to follow these guidelines:",
        details:
            "Campfire Management: Only build fires in designated areas using established fire pits or metal containers. Always keep fires attended and ensure they're completely extinguished before leaving.\n\n"
            "Fire Bans: Before heading out, check for local fire bans, especially during dry conditions.\n\n"
            "Waste Disposal: Avoid burning trash. Instead, pack out all waste for proper disposal.\n\n"
            "Adhering to these practices helps protect Canada's natural landscapes and ensures a safe experience for all.",
        sourceUrl:
            "https://www.nrcan.gc.ca/our-natural-resources/forests/wildland-fires",
      ),
      SafetyArticle(
        title: "Mountain Hiking Safety",
        content:
            "Canada's mountainous terrains offer breathtaking experiences but require careful preparation to ensure safety:",
        details:
            "Route Planning: Research your chosen trail, considering its difficulty, length, and current conditions. Inform someone about your itinerary and expected return time.\n\n"
            "Proper Gear: Dress in layers suitable for changing weather conditions. Wear sturdy, broken-in hiking boots to prevent injuries.\n\n"
            "Weather Awareness: Always check the weather forecast before your hike and be prepared for sudden changes.\n\n"
            "By following these guidelines, hikers can enjoy the majestic beauty of Canada's mountains safely.",
        sourceUrl: "https://www.adventuresmart.ca/land/hiking.htm",
      ),
      SafetyArticle(
        title: "Camping Safety Essentials",
        content:
            "Camping is a cherished Canadian pastime. To ensure a safe and enjoyable experience, consider the following tips:",
        details:
            "Site Selection: Choose campsites away from hazards like dead trees or potential flood areas.\n\n"
            "Wildlife Safety: Store food securely to avoid attracting wildlife. Familiarize yourself with local wildlife and know how to respond to encounters.\n\n"
            "First Aid Preparedness: Carry a well-stocked first aid kit and know basic first aid procedures.\n\n"
            "Being well-prepared enhances the camping experience while ensuring safety for everyone involved.",
        sourceUrl:
            "https://parks.canada.ca/voyage-travel/securite-safety/camping",
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF152314),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 20,
        backgroundColor: const Color(0xFF152314),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == articles.length - 1 ? 120.0 : 0,
                    ),
                    child: _buildSafetyCard(context, articles[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E1D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF101E0F), width: 4),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Text(
        'Safety Tips',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSafetyCard(BuildContext context, SafetyArticle article) {
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SafetyDetailScreen(article: article),
            ),
          ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2E1D),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "IMPROVED BY OFFICIAL SOURCES",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 230,
              child: ElevatedButton.icon(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SafetyDetailScreen(article: article),
                      ),
                    ),
                label: const Text(
                  "Read",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SafetyDetailScreen extends StatelessWidget {
  final SafetyArticle article;

  const SafetyDetailScreen({super.key, required this.article});

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E1D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF101E0F), width: 4),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: const Text(
        'Safety Tips > Reading',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  void _shareArticle(BuildContext context) {
    Share.share(
      '${article.title}\n\n${article.content}\n\nRead more: ${article.sourceUrl}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF152314),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 20,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                article.content,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 16),
              Text(
                article.details,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      label: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    onPressed: () => _shareArticle(context),
                    child: const Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (await canLaunchUrl(Uri.parse(article.sourceUrl))) {
                      await launchUrl(Uri.parse(article.sourceUrl));
                    }
                  },
                  label: const Text(
                    "Source",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  icon: const Icon(Icons.link, color: Colors.black, size: 28),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

class SafetyArticle {
  final String title;
  final String content;
  final String details;
  final String sourceUrl;

  SafetyArticle({
    required this.title,
    required this.content,
    required this.details,
    required this.sourceUrl,
  });
}
