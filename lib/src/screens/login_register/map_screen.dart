import 'dart:async';
import 'dart:developer';

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
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<GoogleMapProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bản đồ"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: TextFormField(
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Tìm kiếm',
                ),
                controller: _searchController,
                onChanged: (String? value) {
                  log("Search: ${value!}");
                },
              )),
              IconButton(
                  onPressed: () async {
                    LoadingDialog.showLoadingDialog(context, "Đang tìm kiếm");
                    mapProvider
                        .searchPlace((String msg) {
                          showSnackBar(context, msg);
                        }, _searchController.text.trim())
                        .then((_) => {
                              _goToPlace(mapProvider.address),
                            })
                        .then((_) => {
                              LoadingDialog.hideLoadingDialog(context),
                            });
                  },
                  icon: const Icon(Icons.search)),
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
                      formattedAddress: mapProvider.address.formattedAddress,
                      lat: newPosition.target.latitude,
                      lng: newPosition.target.longitude,
                    ));
                  },
                ),
                const Center(
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
                    icon: const Icon(Icons.my_location),
                    onPressed: () async {
                      if (await requestLocationPermission(context)) {
                        LoadingDialog.showLoadingDialog(
                            context, 'Vui Lòng Đợi');
                        await mapProvider.goToMyLocation((String msg) {
                          showSnackBar(context, msg);
                        });
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('Địa chỉ: ${mapProvider.address.formattedAddress}'),
              Text('Vĩ độ: ${mapProvider.address.lat}'),
              Text('Kinh độ: ${mapProvider.address.lng}'),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      log('Vĩ độ ${mapProvider.address.lat}');
                      log('Kinh đô: ${mapProvider.address.lng}');
                      log(
                          'address: ${mapProvider.address.formattedAddress}');
                      LoadingDialog.showLoadingDialog(context, "Vui long đời");
                      await mapProvider.searchLocation((String msg){
                        showSnackBar(context, msg);
                      });
                      mapProvider.updateStatus();
                      // mapProvider.checkSelectMap();
                      if(mounted)LoadingDialog.hideLoadingDialog(context);
                      if(mounted) Navigator.pop(context);
                      // try {
                      //   LoadingDialog.showLoadingDialog(
                      //       context, "Vui Long Đợi");
                      //   await mapProvider.searchLocation((String msg) {
                      //     showSnackBar(context, msg);
                      //   });
                      //   if (mapProvider.address.formatted_address
                      //           .split(',')
                      //           .length >=
                      //       4) {
                      //     mapProvider.checkSelectMap();
                      //     if(mounted) Navigator.of(context).pop();
                      //   } else {
                      //     if(mounted) showSnackBar(context, "Vui lòng chọn dịa chỉ cụ thể");
                      //   }
                      // } finally {
                      //   LoadingDialog.hideLoadingDialog(context);
                      // }
                    },
                    child: const Text('Chọn')),
              ),
            ],
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
    _searchController.dispose();
    super.dispose();
  }
}
