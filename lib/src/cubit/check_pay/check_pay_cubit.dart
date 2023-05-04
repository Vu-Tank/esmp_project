import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esmp_project/src/models/api_response.dart';

import '../../repositoty/payment_repository.dart';

part 'check_pay_state.dart';

class CheckPayCubit extends Cubit<CheckPayState> {
  CheckPayCubit() : super(CheckPayInitial());
  checkPay({required String orderID, required String token}) async {
    ApiResponse apiResponse = await PaymentRepository.checkPaymentOrder(
        orderID: orderID, token: token);
    if (apiResponse.dataResponse != null) {
      if (isClosed) return;
      if (apiResponse.dataResponse == 1) {
        emit(CheckPaySuccess());
      } else if (apiResponse.dataResponse == 2) {
        emit(CheckPayFailed());
      } else {
        emit(CheckPaying());
      }
    } else {
      if (isClosed) return;
      emit(CheckPayErorr(apiResponse.message.toString()));
    }
  }
}
