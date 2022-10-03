import 'dart:async';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/providers/google_map_provider.dart';
import 'package:esmp_project/src/utils/request_permission.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<GoogleMapProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bản đồ"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                ),
                controller: _searchController,
                onChanged: (String? value) {
                  print("Search: " + value!);
                },
              )),
              IconButton(
                  onPressed: () async {
                    LoadingDialog.showLoadingDialog(context, "Đang tìm kiếm");
                    mapProvider
                        .searchPlace(context, _searchController.text.trim())
                        .then((_) => {
                              _goToPlace(mapProvider.address),
                            })
                        .then((_) => {
                              LoadingDialog.hideLoadingDialog(context),
                            });
                  },
                  icon: Icon(Icons.search)),
            ],
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      zoom: 15,
                      target: LatLng(
                          mapProvider.address.lat, mapProvider.address.lng)),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onCameraMove: (CameraPosition newPosition) async {
                    mapProvider.setLocationByMovingMap(GoogleAddress(
                      formatted_address: mapProvider.address.formatted_address,
                      lat: newPosition.target.latitude,
                      lng: newPosition.target.longitude,
                    ));
                  },
                ),
                Center(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 36,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.my_location),
                    onPressed: () async {
                      if (await requestLocationPermission(context)) {
                        LoadingDialog.showLoadingDialog(
                            context, 'Vui Lòng Đợi');
                        await mapProvider.goToMyLocation(context);
                        _goToPlace(mapProvider.address).then((_) => {
                              LoadingDialog.hideLoadingDialog(context),
                            });
                      } else {
                        showSnackBar(context, 'Chưa cấp quyền vị trí!');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text('Địa chỉ: ${mapProvider.address.formatted_address}'),
                Text('Vĩ độ: ${mapProvider.address.lat}'),
                Text('Kinh độ: ${mapProvider.address.lng}'),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        print('Vĩ độ ${mapProvider.address.lat}');
                        print('Kinh đô: ${mapProvider.address.lng}');
                        LoadingDialog.showLoadingDialog(
                            context, "Vui Long Đợi");
                        mapProvider
                            .searchLocation(context)
                            .then((_) => {
                                  LoadingDialog.hideLoadingDialog(context),
                                })
                            .then((_) => {
                                  if (mapProvider.address.formatted_address
                                          .split(',')
                                          .length >=
                                      4)
                                    {
                                      // Navigator.pop(context);
                                      Navigator.of(context).pop()
                                    }
                                  else
                                    {
                                      showSnackBar(context,
                                          "Vui lòng chọn dịa chỉ cụ thể")
                                    }
                                });
                      },
                      child: Text('Chọn')),
                ),
              ],
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     if (await requestLocationPermission(context)) {
      //       LoadingDialog.showLoadingDialog(context, 'Vui Lòng Đợi');
      //       await mapProvider.goToMyLocation(context);
      //       _goToPlace(mapProvider.lat, mapProvider.lng, mapProvider.address).then((_) =>{
      //         LoadingDialog.hideLoadingDialog(context),
      //       });
      //     } else {
      //       showSnackBar(context, 'Chưa cấp quyền vị trí!');
      //     }
      //   },
      //   child: Icon(Icons.my_location),
      // ),
    );
  }

  Future<void> _goToPlace(GoogleAddress address) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(address.lat, address.lng), zoom: 15),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }
}
