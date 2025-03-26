import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_cubit.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_state.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/saved_places.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/models/places_model.dart';

class ExplorerScreen extends StatefulWidget {
  final void Function({String? coordinates})? onShowInMap;
  final void Function()? backToSafetyTips;

  const ExplorerScreen({super.key, this.onShowInMap, this.backToSafetyTips});

  @override
  _ExplorerScreenState createState() => _ExplorerScreenState();
}

class _ExplorerScreenState extends State<ExplorerScreen> {
  String? selectedCategory;
  bool isLoading = false;
  PlaceItem? selectedPlace;

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _startExploring(List<PlacesCategory> places) {
    setState(() {
      isLoading = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      final category = places.firstWhere(
        (placeCategory) => placeCategory.type == selectedCategory,
      );
      final randomPlace =
          category.items[Random().nextInt(category.items.length)];
      setState(() {
        selectedPlace = randomPlace;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlacesCubit, PlacesState>(
      builder:
          (BuildContext context, PlacesState state) => state.when(
            initial:
                () => const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                ),
            error:
                (String message) => Center(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            loaded: (List<PlacesCategory> places, List<PlaceItem> favourites) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/explore_background.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 5,
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    backgroundColor: Colors.transparent,
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 30.0),
                          if (isLoading)
                            _buildLoadingScreen()
                          else if (selectedPlace != null)
                            _buildResultScreen()
                          else
                            _buildCategorySelection(places),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
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
        'Explorer',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategorySelection(List<PlacesCategory> places) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2E1D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF101E0F), width: 4),
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),
              const Text(
                'Choose the category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 18,
                runSpacing: 18,
                children:
                    places.asMap().entries.map((entry) {
                      int index = entry.key;
                      PlacesCategory place = entry.value;
                      String iconPath = 'assets/images/${index + 1}b.png';
                      return _buildCategoryButton(place.type, iconPath);
                    }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                selectedCategory == null ? null : () => _startExploring(places),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Text(
                'Start Exploring',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.backToSafetyTips,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Safety Tips',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildCategoryButton(String category, String iconPath) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () => _onCategorySelected(category),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 138,
        height: 138,
        decoration: BoxDecoration(
          color: const Color(0xFF101E0F),
          borderRadius: BorderRadius.circular(22),
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(iconPath, width: 32, height: 32),
            const SizedBox(height: 8),
            Text(
              category,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2E1D),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF101E0F), width: 4),
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset('assets/images/compas.png', width: 150, height: 150),
              const SizedBox(height: 24),
              const Text(
                'Adventure Camping',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8.0),
              const Text(
                'Loading the spot for you...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Loading...',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Column(
      children: [
        const SizedBox(height: 24),
        PlaceInfoCard(
          place: selectedPlace!,
          onClose: () {},
          onShowInMap: widget.onShowInMap,
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => selectedPlace = null),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Search Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
