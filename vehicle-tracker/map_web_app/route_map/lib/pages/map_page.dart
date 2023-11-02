import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../blocs/route_map/controllers/route_controllers.dart';
import '../constants.dart';
import '../widgets/map_legends_widget.dart';
import '../widgets/map_tile_widgets.dart';

class RouteMapPage extends StatelessWidget {
  const RouteMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    // * Get the tripId from the URL
    final tripId = Get.parameters['tripid'];
    if (tripId == null) {
      return const Scaffold(
        body: Center(
          child: Text("Trip Id is null"),
        ),
      );
    }

    // * Fetch the data from the API using the tripId
    final mapController = Get.find<RouteControllers>();
    mapController.fetchData(tripId);

    return GetBuilder<RouteControllers>(
      builder: (controller) {
        if (controller.isFetching.isTrue) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: Scaffold(
            //  App Bar (will be used in future)
            // appBar: AppBar(
            //   toolbarHeight: 100,
            //   backgroundColor: theme.colors.white,
            //   centerTitle: false,
            //   title: const MapAppBarWidget(),
            // ),

            // * Flutter Map
            body: FlutterMap(
              // * Map Options
              options: MapOptions(
                center: controller.polyPoints.isNotEmpty ? controller.polyPoints.first : newDelhi,
                zoom: 13,
                maxZoom: 18,
                minZoom: 1,
              ),

              // * Widgets
              nonRotatedChildren: const [
                Align(
                  alignment: Alignment.bottomRight,
                  child: MapLegendsWidget(),
                )
              ],

              // * Layers
              children: [
                // * Tile Layer
                tileLayerWidget(),

                // * Polyline Layer
                polyLineWidget(controller),

                // * Marker Layer
                if (controller.polyPoints.isNotEmpty) markerLayerWidget(controller),
              ],
            ),
          ),
        );
      },
    );
  }
}
