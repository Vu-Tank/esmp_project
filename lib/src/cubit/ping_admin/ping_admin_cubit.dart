import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/repositoty/service_repository.dart';

part 'ping_admin_state.dart';

class PingAdminCubit extends Cubit<PingAdminState> {
  PingAdminCubit() : super(PingAdminInitial());
  pingAdmin({required String token, required int serviceId}) async {
    if (isClosed) return;
    emit(PingAdminLoading());
    ApiResponse apiResponse =
        await ServiceRepository.pingAdmin(token: token, serviceId: serviceId);
    if (apiResponse.isSuccess!) {
      if (isClosed) return;
      emit(PingAdminSuccess());
    } else {
      if (isClosed) return;
      emit(PingAdminFailed(apiResponse.message.toString()));
    }
  }
}
