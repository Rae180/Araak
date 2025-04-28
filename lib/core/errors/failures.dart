// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{

}
class OfflineFailure extends Failure{
  @override

  List<Object?> get props => [];

}

class NetworkErrorFailure extends Failure {
  final String message;
   NetworkErrorFailure({
    required this.message,
  });

  @override
  List<Object?> get props =>[message];
}
