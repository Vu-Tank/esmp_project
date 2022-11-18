import 'dart:developer';

import 'package:esmp_project/src/models/address.dart';
import 'package:esmp_project/src/models/category.dart';
import 'package:esmp_project/src/models/motor.dart';
import 'package:esmp_project/src/models/sort_model.dart';
import 'package:esmp_project/src/models/subCategory.dart';
import 'package:esmp_project/src/providers/item/items_provider.dart';
import 'package:esmp_project/src/screens/google_map/google_map_Screen.dart';
import 'package:esmp_project/src/utils/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/Motor_brand.dart';

// Future<String?> showFilterSearchDialog(BuildContext context) async {
//   String? result = await showDialog<String>(
//       context: context,
//       builder: (context) {
//         return
//       });
//   return result;
// }
class FilterSearchDialog extends StatefulWidget {
  const FilterSearchDialog({Key? key}) : super(key: key);

  @override
  State<FilterSearchDialog> createState() => _FilterSearchDialogState();
}

class _FilterSearchDialogState extends State<FilterSearchDialog> {
  TextEditingController _minController= TextEditingController();
  TextEditingController _maxController= TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _maxController.dispose();
    _minController.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width= MediaQuery.of(context).size.width;
    return Consumer<ItemsProvider>(builder: (context, filter, __) {
      if(filter.maxPrice!=null){
        _maxController=TextEditingController(text: filter.maxPrice!.toInt().toString());
        _maxController.selection =
            TextSelection.collapsed(offset: _maxController.text.length);
      }
      if(filter.minPrice!=null){
        _minController=TextEditingController(text: filter.minPrice!.toInt().toString());
        _minController.selection =
            TextSelection.collapsed(offset: _minController.text.length);
      }
      return AlertDialog(
        insetPadding: const EdgeInsets.only(left: 0, right: 0),
        title: const Center(child: Text('Bộ Lọc')),
        actions: <Widget>[
          Column(
            children: <Widget>[
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: IntrinsicColumnWidth(),
                  // 1: FlexColumnWidth(),
                  1: FixedColumnWidth(220),
                },
                children: [
                  TableRow(children: [
                    Text(
                      'Nhóm chính',
                      style: textStyleInput,
                    ),
                    DropdownButton(
                        value: filter.selectedCategory,
                        icon: const Icon(Icons.arrow_downward),
                        isExpanded: true,
                        elevation: 10,
                        style: textStyleLabel,
                        underline: Container(
                          height: 2,
                          color: Colors.cyan,
                        ),
                        items: filter.category
                            .map<DropdownMenuItem<Category>>(
                                (Category value) {
                              return DropdownMenuItem<Category>(
                                value: value,
                                child: Text(
                                  value.name,
                                  textAlign: TextAlign.end,
                                ),
                              );
                            }).toList(),
                        onChanged: (Category? value) {
                          if (value != null) {
                            filter.selectNewCategory(value);
                          }
                          // log(value.toString());
                        }),
                  ]),
                  if (filter.selectedCategory.categoryID != -1 && filter.subCategory.length>1)
                    TableRow(children: [
                      Text(
                        'Loại phụ tùng',
                        style: textStyleInput,
                      ),
                      DropdownButton(
                          value: filter.selectedSubCategory,
                          icon: const Icon(Icons.arrow_downward),
                          isExpanded: true,
                          elevation: 10,
                          style: textStyleLabel,
                          underline: Container(
                            height: 2,
                            color: Colors.cyan,
                          ),
                          items: filter.subCategory
                              .map<DropdownMenuItem<SubCategory>>(
                                  (SubCategory value) {
                                return DropdownMenuItem<SubCategory>(
                                  value: value,
                                  child: Text(value.subcategoryName, textAlign: TextAlign.end,),
                                );
                              }).toList(),
                          onChanged: (SubCategory? value) {
                            if (value != null) {
                              filter.selectNewSubCategory(value);
                            }
                            // log(value.toString());
                          }),
                    ]),
                  TableRow(children: [
                    Text(
                      'Hãng xe sử dụng',
                      style: textStyleInput,
                    ),
                    DropdownButton(
                        value: filter.selectedMotorBrand,
                        icon: const Icon(Icons.arrow_downward),
                        isExpanded: true,
                        elevation: 10,
                        style: textStyleLabel,
                        underline: Container(
                          height: 2,
                          color: Colors.cyan,
                        ),
                        items: filter.listMotorBrand
                            .map<DropdownMenuItem<MotorBrand>>(
                                (MotorBrand value) {
                              return DropdownMenuItem<MotorBrand>(
                                value: value,
                                child: Text(value.name, textAlign: TextAlign.end,),
                              );
                            }).toList(),
                        onChanged: (MotorBrand? value) {
                          if (value != null) {
                            filter.selectedNewMotorBrand(value);
                          }
                          // log(value.toString());
                        }),
                  ]),
                  if(filter.motor.length>1&& filter.selectedMotorBrand.brandID!=-1)
                    TableRow(children: [
                      Text(
                        'Loại xe sử dụng',
                        style: textStyleInput,
                      ),
                      DropdownButton(
                          value: filter.seletedMotor,
                          icon: const Icon(Icons.arrow_downward),
                          isExpanded: true,
                          elevation: 10,
                          style: textStyleLabel,
                          underline: Container(
                            height: 2,
                            color: Colors.cyan,
                          ),
                          items: filter.motor
                              .map<DropdownMenuItem<Motor>>(
                                  (Motor value) {
                                return DropdownMenuItem<Motor>(
                                  value: value,
                                  child: Text(value.name, textAlign: TextAlign.end,),
                                );
                              }).toList(),
                          onChanged: (Motor? value) {
                            if (value != null) {
                              filter.selectedNewMotor(value);
                            }
                            // log(value.toString());
                          },

                      ),
                    ]),
                  // rating
                  TableRow(
                      children: <Widget>[
                        Text('Đánh giá', style: textStyleInput,),
                        DropdownButton(
                            value: filter.selectedrating,
                            icon: const Icon(Icons.arrow_downward),
                            isExpanded: true,
                            elevation: 10,
                            style: textStyleLabel,
                            underline: Container(
                              height: 2,
                              color: Colors.cyan,
                            ),
                            items: filter.ratings
                                .map<DropdownMenuItem<int>>(
                                    (int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: (value==0)
                                      ? const Text('Tất cả')
                                        :Row(
                                      children: [
                                        Text(value.toString()),
                                        const Icon(Icons.star, color: Colors.yellowAccent,),
                                      ],
                                    ),
                                  );
                                }).toList(),
                            onChanged: (int? value) {
                              if (value != null) {
                                filter.selectedNewRating(value);
                              }
                              // log(value.toString());
                            }),
                      ]
                  ),
                  //sắp xếp
                  TableRow(
                      children: <Widget>[
                        Text('Sắp xếp', style: textStyleInput,),
                        DropdownButton(
                            value: filter.selectedSortModel,
                            icon: const Icon(Icons.arrow_downward),
                            isExpanded: true,
                            elevation: 10,
                            style: textStyleLabel,
                            underline: Container(
                              height: 2,
                              color: Colors.cyan,
                            ),
                            items: filter.listSortModel
                                .map<DropdownMenuItem<SortModel>>(
                                    (SortModel value) {
                                  return DropdownMenuItem<SortModel>(
                                    value: value,
                                    child: Text(
                                      value.name,
                                      textAlign: TextAlign.end,
                                    ),
                                  );
                                }).toList(),
                            onChanged: (SortModel? value) {
                              if (value != null) {
                                filter.selectedNewSortModel(value);
                              }
                              // log(value.toString());
                            }),
                      ]
                  ),
                  // theo khu vuc
                  TableRow(
                    children: <Widget>[
                      Text('Vị trí', style: textStyleInput,),
                      SizedBox(child: OutlinedButton(
                        onPressed: ()async{
                          AddressModel? address= await Navigator.push(context, MaterialPageRoute(builder: (context)=> GoogleMapScreen(status: 'search')));
                          if(address!=null){
                            filter.selectedAddress(address);
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: filter.address==null? Colors.white: Colors.green,
                        ),
                        child: Text('Chọn',style: textStyleInput,),
                      ))
                    ]
                  )
                ],
              ),
              //min max price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    width: width*2/5,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tối thiểu',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorText: filter.minPriceValid.error,
                        errorStyle: textStyleError
                      ),
                      onTap: (){
                        _minController.selection =
                            TextSelection.collapsed(offset: _minController.text.length);
                      },
                      onSubmitted: (String? value){
                        log(value.toString());
                      },
                      keyboardType: TextInputType.number,
                      controller: _minController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      maxLength: 10,
                      onChanged: (String? value){
                        if(value!=null&&value.isNotEmpty){
                          filter.minPrice=double.parse(value);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: width*2/5,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tối đa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        errorText: filter.maxPriceValid.error,
                        errorStyle: textStyleError
                      ),
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      onTap: (){
                        _maxController.selection =
                            TextSelection.collapsed(offset: _maxController.text.length);
                      },
                      onChanged: (String? value){
                        if(value!=null&& value.isNotEmpty){
                          filter.maxPrice=double.parse(value);
                        }
                      },
                      controller: _maxController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlinedButton(
                      onPressed: () {
                        filter.reset();
                        Navigator.pop(context,null);
                      }, child: Text('Thiết lập lại')),
                  ElevatedButton(
                      onPressed: ()async {
                        if(_maxController.text.trim().isNotEmpty){
                          if(!filter.validMaxPrice(double.parse(_maxController.text.trim()))){
                            return;
                          }
                        }
                        if(_minController.text.trim().isNotEmpty){
                          if(!filter.validMinPrice(double.parse(_minController.text.trim()))){
                            return;
                          }
                        }
                        log('ok');
                        Navigator.pop(context,filter.getSearchModel());

                      }, child: Text('Áp dụng')),
                ],
              ),
            ],
          ),
        ],
      );
    });
  }
}

