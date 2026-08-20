import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../domain/entities/training_entities/exercise_entity.dart';
import '../../../../features/training/domain/usecases/get_exercises_usecase.dart';

class ExerciseController extends GetxController {
  final GetExercisesUseCase getExercisesUseCase;

  ExerciseController({required this.getExercisesUseCase});

  final RxList<ExerciseEntity> exercises = <ExerciseEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final RxString currentFilter = 'All'.obs;
  final RxString searchQuery = ''.obs;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;
  String _currentSearchTerm = '';

  List<ExerciseEntity> get visibleExercises => exercises;

  @override
  void onInit() {
    super.onInit();
    _fetchInitialExercises();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> _fetchExercises({required bool reset}) async {
    if (reset) {
      isLoading.value = true;
      errorMessage.value = '';
      _currentPage = 1;
      _hasMoreData = true;
      exercises.clear();
    } else {
      isFetchingMore.value = true;
    }

    final result = await getExercisesUseCase(
      muscleCategory: currentFilter.value == 'All' ? null : currentFilter.value,
      page: _currentPage,
      limit: _limit,
      searchTerm: _currentSearchTerm.isEmpty ? null : _currentSearchTerm,
    );

    result.fold(
      (failure) {
        if (reset) {
          errorMessage.value = failure.message;
          isLoading.value = false;
        } else {
          _currentPage--;
          Get.snackbar('Error', 'Failed to load more exercises');
          isFetchingMore.value = false;
        }
      },
      (data) {
        if (data.length < _limit) {
          _hasMoreData = false;
        }

        if (reset) {
          exercises.assignAll(data);
          isLoading.value = false;
        } else {
          exercises.addAll(data);
          isFetchingMore.value = false;
        }
      },
    );
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore.value &&
        !isLoading.value &&
        _hasMoreData) {
      _fetchMoreExercises();
    }
  }

  Future<void> _fetchInitialExercises() async {
    await _fetchExercises(reset: true);
  }

  Future<void> _fetchMoreExercises() async {
    _currentPage++;
    await _fetchExercises(reset: false);
  }

  void setFilter(String filter) {
    if (currentFilter.value == filter) return;
    currentFilter.value = filter;
    _fetchInitialExercises();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _currentSearchTerm = query.trim();
      _fetchInitialExercises();
    });
  }
}
