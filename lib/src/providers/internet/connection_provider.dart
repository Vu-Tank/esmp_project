import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
class ConnectionProvider extends ChangeNotifier{
    final Connectivity _connectivity= Connectivity();

    bool? _isOnline;
    bool? get isOnline=> _isOnline;

    startMonitoring() async{
        await initConnectivity();
        _connectivity.onConnectivityChanged.listen((result) async {
           if(result == ConnectivityResult.none){
               _isOnline=false;
               notifyListeners();
           }else{
               await _updateConnectuinStatus().then((value) => {
                   _isOnline= value,
                   notifyListeners()
               });
           }
        });
    }
    Future<void> initConnectivity() async{
        try{
            var status= await _connectivity.checkConnectivity();
            if(status==ConnectivityResult.none){
                _isOnline=false;
                notifyListeners();
            }else{
                _isOnline=true;
                notifyListeners();
            }
        } on PlatformException catch(e){
            log("error at initConnectivity: $e");
        }
    }
    Future<bool> _updateConnectuinStatus() async{
        bool isConnected=false;
        try{
            final List<InternetAddress> result= await InternetAddress.lookup('google.com');
            if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                isConnected=true;
            }
        }on SocketException catch(_){
            isConnected=false;
        }
        return isConnected;
    }
}