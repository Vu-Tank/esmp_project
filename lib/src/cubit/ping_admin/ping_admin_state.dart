part of 'ping_admin_cubit.dart';

abstract class PingAdminState extends Equatable {
  const PingAdminState();

  @override
  List<Object> get props => [];
}

class PingAdminInitial extends PingAdminState {}

class PingAdminLoading extends PingAdminState {}

class PingAdminSuccess extends PingAdminState {}

class PingAdminFailed extends PingAdminState {
  final String msg;
  const PingAdminFailed(this.msg);
  @override
  // TODO: implement props
  List<Object> get props => [msg];
}
