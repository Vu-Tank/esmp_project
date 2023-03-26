import 'package:bloc/bloc.dart';

part 'service_type_state.dart';

class ServiceTypeCubit extends Cubit<ServiceTypeState> {
  ServiceTypeCubit()
      : super(ServiceTypeState(serviceType: "Trả hàng và Hoàn tiền"));

  void changServiceType(String newServiceType) =>
      emit(ServiceTypeState(serviceType: newServiceType));
}
