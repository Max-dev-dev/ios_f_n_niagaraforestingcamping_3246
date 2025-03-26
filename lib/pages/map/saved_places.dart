import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_cubit.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_state.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/models/places_model.dart';
import 'package:share_plus/share_plus.dart';

class SavedPlaces extends StatefulWidget {
  final void Function({String? coordinates})? onShowInMap;

  const SavedPlaces({super.key, this.onShowInMap});

  @override
  _SavedPlacesState createState() => _SavedPlacesState();
}

class _SavedPlacesState extends State<SavedPlaces> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 5,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 10),
            Expanded(
              child: BlocBuilder<PlacesCubit, PlacesState>(
                builder: (BuildContext context, PlacesState state) {
                  if (state is Loaded) {
                    final List<PlaceItem> favourites = state.favourites;
                    if (favourites.isEmpty) {
                      return const Center(
                        child: Text(
                          'No saved places yet',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: favourites.length,
                      itemBuilder: (BuildContext context, int index) {
                        final PlaceItem place = favourites[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == favourites.length - 1 ? 120 : 16,
                          ),
                          child: PlaceInfoCard(
                            place: place,
                            onClose: () {
                              context.read<PlacesCubit>().removeFromFavourites(
                                place,
                              );
                            },
                            onShowInMap: widget.onShowInMap,
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Failed to load saved places',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    );
                  }
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
        'Saved Camps',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PlaceInfoCard extends StatefulWidget {
  final PlaceItem place;
  final VoidCallback onClose;
  final void Function({String? coordinates})? onShowInMap;

  const PlaceInfoCard({super.key, required this.place, required this.onClose, this.onShowInMap});

  @override
  State<PlaceInfoCard> createState() => _PlaceInfoCardState();
}

class _PlaceInfoCardState extends State<PlaceInfoCard> {
  void _sharePlace() {
    final String shareText =
        "Check out this place: ${widget.place.title}\n\n${widget.place.description}\n\nCoordinates: ${widget.place.coordinates}";
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    clipBehavior: Clip.antiAlias,
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E2E1D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF101E0F), width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  widget.place.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.place.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.place.description,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Coordinates: ${widget.place.coordinates}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onShowInMap?.call(
                            coordinates: widget.place.coordinates,
                          );
                        },
                        label: const Text(
                          "Show in Map",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    FavouriteButton(place: widget.place),
                    const SizedBox(width: 12.0),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: _sharePlace,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class FavouriteButton extends StatelessWidget {
  final PlaceItem place;

  const FavouriteButton({super.key, required this.place});

  @override
  Widget build(BuildContext context) => BlocBuilder<PlacesCubit, PlacesState>(
    builder: (BuildContext context, PlacesState state) {
      if (state is! Loaded) return const SizedBox.shrink();

      final bool isFavourite = state.favourites.any(
        (PlaceItem p) => p.title == place.title,
      );
      final PlacesCubit cubit = context.read<PlacesCubit>();

      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          onPressed: () {
            if (isFavourite) {
              cubit.removeFromFavourites(place);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Places has been successfully removed from favourites',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              cubit.addToFavourites(place);
            }
          },
          icon: Icon(
            Icons.bookmark,
            color: isFavourite ? const Color(0xFFE7C563) : Colors.white,
          ),
          iconSize: 20,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      );
    },
  );
}
