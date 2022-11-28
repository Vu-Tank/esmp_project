
import 'package:esmp_project/src/models/order_detail.dart';
import 'package:esmp_project/src/models/order_ship.dart';
import 'package:esmp_project/src/models/order_status.dart';
import 'package:esmp_project/src/models/store.dart';

class Order {
  int orderID;
  Store store;
  String createDate;
  double priceItem;
  double feeShip;
  String pickProvince;
  String pickDistrict;
  String pickWard;
  String pickAddress;
  String pickTel;
  String pickName;
  String province;
  String district;
  String ward;
  String address;
  String tel;
  String name;
  List<OrderDetail> details;
  StatusOrder orderStatus;
  OrderShip? orderShip;
  String? reason;
  String? pickTime;

  Order(
      {required this.orderID,
      required this.store,
      required this.createDate,
      required this.priceItem,
      required this.feeShip,
      required this.pickProvince,
      required this.pickDistrict,
      required this.pickWard,
      required this.pickAddress,
      required this.pickTel,
      required this.pickName,
      required this.province,
      required this.district,
      required this.ward,
      required this.address,
      required this.tel,
      required this.name,
      required this.details,
      required this.orderStatus,
      this.orderShip,
      this.reason,
      this.pickTime});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        orderID: json['orderID'] as int,
        store: Store.fromJson(json['storeView']),
        createDate: json['create_Date'] as String,
        priceItem: double.parse(json['priceItem'].toString()),
        feeShip: double.parse(json['feeShip'].toString()),
        pickProvince: json['pick_Province'] as String,
        pickDistrict: json['pick_District'] as String,
        pickWard: json['pick_Ward'] as String,
        pickAddress: json['pick_Address'] as String,
        pickTel: json['pick_Tel'] as String,
        pickName: json['pick_Name'] as String,
        province: json['province'] as String,
        district: json['district'] as String,
        ward: json['ward'] as String,
        address: json['address'] as String,
        tel: json['tel'] as String,
        name: json['name'] as String,
        details: (json['details'] as List).map((orderDetail) => OrderDetail.fromJson(orderDetail)).toList(),
        orderStatus: StatusOrder.fromJson(json['orderStatus']),
        orderShip: (json['orderShip']==null)?null:OrderShip.fromJson(json['orderShip']),
        reason: json['reason'],
        pickTime: json['pick_Time'],
    );
  }
  double getPrice(){
    double price=0;
    for(OrderDetail od in details){
      price+= (od.amount*od.pricePurchase*(1-od.discountPurchase));
    }
    return price;
  }
  double getTotalPrice(){
    return priceItem+feeShip;
  }

  @override
  String toString() {
    return 'Order{orderID: $orderID, store: $store, createDate: $createDate, priceItem: $priceItem, feeShip: $feeShip, pickProvince: $pickProvince, pickDistrict: $pickDistrict, pickWard: $pickWard, pickAddress: $pickAddress, pickTel: $pickTel, pickName: $pickName, province: $province, district: $district, ward: $ward, address: $address, tel: $tel, name: $name, details: $details, orderStatus: $orderStatus, orderShip: $orderShip}';
  }
}
