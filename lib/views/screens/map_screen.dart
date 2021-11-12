import 'package:eigital_sample_app/cubit/map_cubit.dart';
import 'package:eigital_sample_app/cubit/map_state.dart';
import 'package:eigital_sample_app/views/res/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapCubit cubit = BlocProvider.of(context);
    return BlocConsumer<MapCubit, MapState>(
      listener: (BuildContext context, MapState state) {},
      builder: (BuildContext context, MapState state) {
        return Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: cubit.defaultPosition,
              onMapCreated: (GoogleMapController controller) {
                cubit.controller.complete(controller);
              },
              markers: cubit.createMarker(),
              polylines: Set<Polyline>.of(cubit.polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
            _buildButons(cubit),
          ],
        );
      },
    );
  }

  Widget _buildButons(MapCubit cubit) {
    return BlocConsumer<MapCubit, MapState>(
      listener: (BuildContext context, MapState state) {},
      builder: (BuildContext context, MapState state) {
        if (state is MapLoaded) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (state.showNavigationButton) _buildDistanceText(cubit),
                const SizedBox(width: 8),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  _buildRandomButton(cubit),
                  const SizedBox(width: 8),
                  if (state.showNavigationButton) _buildNavigateButton(cubit),
                  const SizedBox(width: 8),
                ])
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  TextButton _buildRandomButton(MapCubit cubit) {
    return TextButton(
      onPressed: () {
        cubit.generateRandomLocation();
      },
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(const Size.fromWidth(150)),
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: const Text(
        'Random Location',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  TextButton _buildNavigateButton(MapCubit cubit) {
    return TextButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(const Size.fromWidth(150)),
        padding:
            MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: () {
        cubit.createPolylines();
      },
      child: const Text(
        'Navigate',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Text _buildDistanceText(MapCubit cubit) {
    return Text(
      '${cubit.totalDistance.toStringAsFixed(2)} KM',
      style: kText30TextStyle,
    );
  }
}
