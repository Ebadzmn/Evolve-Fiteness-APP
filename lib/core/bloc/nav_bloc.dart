import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavEvent extends Equatable {
  final int index;
  const NavEvent(this.index);
  @override
  List<Object?> get props => [index];
}

class NavState extends Equatable {
  final int index;
  const NavState(this.index);
  @override
  List<Object?> get props => [index];
}

class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState(0)) {
    on<NavEvent>((event, emit) => emit(NavState(event.index)));
  }
}
