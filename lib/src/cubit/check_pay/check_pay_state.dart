part of 'check_pay_cubit.dart';

abstract class CheckPayState extends Equatable {
  const CheckPayState();

  @override
  List<Object> get props => [];
}

class CheckPayInitial extends CheckPayState {}

class CheckPaying extends CheckPayState {}

class CheckPaySuccess extends CheckPayState {}

class CheckPayFailed extends CheckPayState {}

class CheckPayErorr extends CheckPayState {
  final String msg;
  const CheckPayErorr(this.msg);
  @override
  List<Object> get props => [msg];
}
