import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:esmp_project/src/models/api_response.dart';
import 'package:esmp_project/src/models/feedback.dart';
import 'package:esmp_project/src/repositoty/item_repository.dart';

part 'feedback_state.dart';

class ItemFeedbackCubit extends Cubit<ItemFeedbackState> {
  ItemFeedbackCubit() : super(ItemFeedbackInitial());
  loadFeedback({required int itemID, required int page}) async {
    if (isClosed) return;
    emit(ItemFeedbackLoading());
    ApiResponse apiResponse = await ItemRepository.getFeedbackItemDetail(
      itemID: itemID,
      page: page,
    );
    if (apiResponse.isSuccess!) {
      if (isClosed) return;
      emit(ItemFeedbackLoaded(
          feedbacks: apiResponse.dataResponse,
          currentPage: page,
          totalPage: apiResponse.totalPage!));
    } else {
      if (isClosed) return;
      emit(
          ItemFeedbackLoadFailed(currentPage: page, msg: apiResponse.message!));
    }
  }
}
