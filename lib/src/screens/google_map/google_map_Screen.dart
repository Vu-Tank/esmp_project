import 'dart:async';
import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/providers/user/address_provider.dart';
import 'package:esmp_project/src/providers/map/map_provider.dart';
import 'package:esmp_project/src/utils/request_permission.dart';
import 'package:esmp_project/src/utils/widget/loading_dialog.dart';
import 'package:esmp_project/src/utils/widget/showSnackBar.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapScreen extends StatefulWidget {
  GoogleMapScreen({Key? key, required this.status, this.addressModel})
      : super(key: key);
  final String status;
  AddressModel? addressModel;

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.status == "edit") {
      context.read<MapProvider>().initData(widget.addressModel);
    } else if (widget.status == "create") {
      context.read<MapProvider>().initData(null);
    } else if (widget.status == "search") {
      context.read<MapProvider>().initData(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = Provider.of<MapProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Bản đồ", style: appBarTextStyle),
        centerTitle: true,
        backgroundColor: mainColor,
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
                height: 53,
                child: ElevatedButton(
                  onPressed: () async {
                    await mapProvider.searchLocation((String msg) {
                      showSnackBar(context, msg);
                    });
                    if (widget.status == 'edit') {
                      AddressModel? add = mapProvider.getAddress();
                      if (add != null) {
                        if (mounted)
                          context.read<AddressProvider>().setNewAddress(add);
                      }
                    }
                    if (mounted)
                      Navigator.pop(context, mapProvider.getAddress());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: btnColor,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: Text(
                    'Chọn',
                    style: btnTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
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
