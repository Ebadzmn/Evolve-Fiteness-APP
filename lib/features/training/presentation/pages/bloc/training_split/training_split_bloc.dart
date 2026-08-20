// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fitness_app/features/training/domain/usecases/get_training_split_usecase.dart';
// import 'training_split_event.dart';
// import 'training_split_state.dart';

// class TrainingSplitBloc extends Bloc<TrainingSplitEvent, TrainingSplitState> {
//   final GetTrainingSplitUseCase getSplit;

//   TrainingSplitBloc({required this.getSplit})
//     : super(const TrainingSplitState()) {
//     on<TrainingSplitLoadRequested>(_onLoadRequested);
//   }

//   Future<void> _onLoadRequested(
//     TrainingSplitLoadRequested event,
//     Emitter<TrainingSplitState> emit,
//   ) async {
//     emit(state.copyWith(status: TrainingSplitStatus.loading));
//     try {
//       final split = await getSplit();
//       emit(state.copyWith(status: TrainingSplitStatus.success, split: split));
//     } catch (e) {
//       emit(
//         state.copyWith(
//           status: TrainingSplitStatus.failure,
//           errorMessage: e.toString(),
//         ),
//       );
//     }
//   }
// }
