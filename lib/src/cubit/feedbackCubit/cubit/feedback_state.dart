part of 'feedback_cubit.dart';

abstract class ItemFeedbackState extends Equatable {
  const ItemFeedbackState();

  @override
  List<Object> get props => [];
}

class ItemFeedbackInitial extends ItemFeedbackState {}

class ItemFeedbackLoading extends ItemFeedbackState {}

class ItemFeedbackLoaded extends ItemFeedbackState {
  final List<FeedBackData> feedbacks;
  final int totalPage;
  final int currentPage;
  const ItemFeedbackLoaded(
      {required this.feedbacks,
      required this.currentPage,
      required this.totalPage});
  @override
  List<Object> get props => [feedbacks, totalPage, currentPage];
}

class ItemFeedbackLoadFailed extends ItemFeedbackState {
  final String msg;
  final int currentPage;
  const ItemFeedbackLoadFailed({required this.msg, required this.currentPage});
  @override
  // TODO: implement props
  List<Object> get props => [msg, currentPage];
}
