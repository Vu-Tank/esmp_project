import 'package:bloc/bloc.dart';

part 'payment_method_state.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  PaymentMethodCubit() : super(PaymentMethodState(paymentMethod: "MOMO"));
  void momoPayment() => emit(PaymentMethodState(paymentMethod: "MOMO"));
  void codPayment() => emit(PaymentMethodState(paymentMethod: "COD"));
}
