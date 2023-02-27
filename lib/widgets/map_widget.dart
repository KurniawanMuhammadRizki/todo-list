import 'package:flutter/material.dart';
import 'package:todo_list/models/place_location.dart';
import 'package:todo_list/screens/map_screen.dart';
import 'package:todo_list/services/location_service.dart';

class MapWidget extends StatelessWidget {
  const MapWidget(
      {Key? key, required this.placeLocation, required this.setLocationFn})
      : super(key: key);
  final PlaceLocation placeLocation;
  final Function(PlaceLocation placeLocation) setLocationFn;

  @override
  Widget build(BuildContext context) {
    String previewMapImageUrl = LocationService.generateMapUrlImage(
      placeLocation.latitude,
      placeLocation.longitude,
    );
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => MapScreen(
              initialLocation: placeLocation,
              setLocationFn: setLocationFn,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: previewMapImageUrl.isEmpty
            ? Padding(
                padding: EdgeInsets.all(15),
                child: Center(child: Text('Tap untuk menambahkan lokasi')))
            : Stack(
                children: [
                  Image.network(previewMapImageUrl),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        setLocationFn(
                            PlaceLocation(latitude: 0.0, longitude: 0.0));
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
