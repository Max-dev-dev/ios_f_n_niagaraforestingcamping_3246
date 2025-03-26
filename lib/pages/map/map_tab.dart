import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_cubit.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/cubit/places_state.dart';
import 'package:ios_f_n_niagaraforestcamping_3246/pages/map/models/places_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';

class MapPage extends StatefulWidget {
  final String? initialCoordinates;

  const MapPage({super.key, this.initialCoordinates});

  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapPage> {
  final MapController _mapController = MapController();
  bool showInfo = false;
  PlaceItem? selectedPlace;
  double currentZoom = 12.0;

  @override
  void initState() {
    super.initState();
    context.read<PlacesCubit>().loadPlaces();
    if (widget.initialCoordinates != null) {
      final LatLng? initialPoint = _parseCoordinates(
        widget.initialCoordinates!,
      );
      if (initialPoint != null) {
        Future.delayed(Duration.zero, () {
          _mapController.move(initialPoint, 14.0);
        });
      }
    }
  }

  LatLng? _parseCoordinates(String coordinates) {
    try {
      final List<String> parts = coordinates.split(',');

      if (parts.length != 2) {
        return null;
      }

      double parsedLat = double.parse(
        parts[0].replaceAll(RegExp(r'[^0-9.-]'), '').trim(),
      );
      double parsedLng = double.parse(
        parts[1].replaceAll(RegExp(r'[^0-9.-]'), '').trim(),
      );

      if (coordinates.contains('W')) {
        parsedLng = -parsedLng;
      }

      if (coordinates.contains('S')) {
        parsedLat = -parsedLat;
      }

      return LatLng(parsedLat, parsedLng);
    } catch (e) {
      print("Помилка при розборі координат: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
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
              (String message) => const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
          loaded: (List<PlacesCategory> places, List<PlaceItem> favourites) {
            final List<Marker> markers = <Marker>[];
            for (final PlacesCategory category in places) {
              for (final PlaceItem place in category.items) {
                final LatLng? point = _parseCoordinates(place.coordinates);
  
                if (point != null) {
                  markers.add(
                    Marker(
                      point: point,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPlace = place;
                            showInfo = true;
                            _mapController.move(point, 14.0);
                          });
                        },
                        child: const Icon(
                          Icons.place,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  );
                }
              }
            }
            return Stack(
              children: <Widget>[
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter:
                        widget.initialCoordinates != null
                            ? _parseCoordinates(widget.initialCoordinates!) ??
                                const LatLng(43.2550, 79.0350)
                            : (markers.isNotEmpty
                                ? markers.first.point
                                : const LatLng(43.2550, 79.0350)),
                    initialZoom: currentZoom,
                    minZoom: 2,
                    maxZoom: 18,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                    onTap: (TapPosition tapPosition, LatLng point) {
                      setState(() {
                        showInfo = false;
                      });
                    },
                  ),
                  children: <Widget>[
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      tileBuilder: _darkModeTileBuilder,
                    ),
                    MarkerLayer(markers: markers),
                  ],
                ),
                Positioned(
                  top: 60,
                  left: 20,
                  right: 20,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2E1D),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFF101E0F),
                        width: 4,
                      ),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      'Map',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (showInfo && selectedPlace != null)
                  Positioned(
                    bottom: screenWidth > 375 ? 200 : 120,
                    left: 20,
                    right: 20,
                    child: PlaceInfoCard(
                      place: selectedPlace!,
                      onClose: () {
                        setState(() {
                          showInfo = false;
                        });
                      },
                    ),
                  ),
                Positioned(
                  bottom: screenWidth > 375 ? 120 : 100,
                  right: 20,
                  child: Column(
                    children: <Widget>[
                      _buildZoomButton(Icons.add, () {
                        setState(() {
                          currentZoom = (currentZoom + 1).clamp(2.0, 18.0);
                          _mapController.move(
                            _mapController.camera.center,
                            currentZoom,
                          );
                        });
                      }),
                      const SizedBox(height: 10),
                      _buildZoomButton(Icons.remove, () {
                        setState(() {
                          currentZoom = (currentZoom - 1).clamp(2.0, 18.0);
                          _mapController.move(
                            _mapController.camera.center,
                            currentZoom,
                          );
                        });
                      }),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
  );
  }

  Widget _darkModeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        -0.2126,
        -0.7152,
        -0.0722,
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]),
      child: tileWidget,
    );
  }

  Widget _buildZoomButton(IconData icon, VoidCallback onPressed) => Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: Colors.black87,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      iconSize: 30,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    ),
  );
}

class PlaceInfoCard extends StatefulWidget {
  final PlaceItem place;
  final VoidCallback onClose;

  const PlaceInfoCard({super.key, required this.place, required this.onClose});

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
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: widget.onClose,
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
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
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
