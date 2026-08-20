import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_nutrition_statistics_usecase.dart';
import 'nutrition_statistics_event.dart';
import 'nutrition_statistics_state.dart';

class NutritionStatisticsBloc
    extends Bloc<NutritionStatisticsEvent, NutritionStatisticsState> {
  final GetNutritionStatisticsUseCase getStatistics;

  NutritionStatisticsBloc({required this.getStatistics})
    : super(NutritionStatisticsState(date: DateTime.now())) {
    on<NutritionStatisticsLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    NutritionStatisticsLoadRequested event,
    Emitter<NutritionStatisticsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: NutritionStatisticsStatus.loading,
        date: event.date,
      ),
    );
    try {
      final result = await getStatistics(event.date);
      emit(
        state.copyWith(
          status: NutritionStatisticsStatus.success,
          statistics: result,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NutritionStatisticsStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
