import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import '../../../../domain/entities/nutrition_entities/food_item_entity.dart';
import '../../../../features/nutrition/domain/usecases/get_food_items_usecase.dart';

class FoodItemsController extends GetxController {
  final GetFoodItemsUseCase getFoodItemsUseCase;

  FoodItemsController({required this.getFoodItemsUseCase});

  final RxList<FoodItemEntity> foodItems = <FoodItemEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isFetchingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<FoodCategory> currentFilter = FoodCategory.all.obs;
  final RxString searchQuery = ''.obs;

  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMoreData = true;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  // Derive visible items based on search and current category
  List<FoodItemEntity> get visibleItems {
    return foodItems.toList();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchInitialFoodItems();
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
        !isFetchingMore.value &&
        !isLoading.value &&
        _hasMoreData) {
      _fetchMoreFoodItems();
    }
  }

  Future<void> _fetchInitialFoodItems() async {
    // Only show full-page loader if we don't have any items yet
    if (foodItems.isEmpty) {
      isLoading.value = true;
    }
    
    errorMessage.value = '';
    _currentPage = 1;
    _hasMoreData = true;

    String? searchValue = searchQuery.value.isNotEmpty ? searchQuery.value : null;
    String? filterValue = currentFilter.value != FoodCategory.all ? currentFilter.value.name : null;

    try {
      final result = await getFoodItemsUseCase(
        page: _currentPage,
        limit: _limit,
        search: searchValue,
        filter: filterValue,
      );

      if (result.length < _limit) {
        _hasMoreData = false;
      }
      foodItems.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchMoreFoodItems() async {
    isFetchingMore.value = true;
    _currentPage++;

    String? searchValue = searchQuery.value.isNotEmpty ? searchQuery.value : null;
    String? filterValue = currentFilter.value != FoodCategory.all ? currentFilter.value.name : null;

    try {
      final result = await getFoodItemsUseCase(
        page: _currentPage,
        limit: _limit,
        search: searchValue,
        filter: filterValue,
      );

      if (result.isEmpty || result.length < _limit) {
        _hasMoreData = false;
      }
      foodItems.addAll(result);
    } catch (e) {
      _currentPage--;
      Get.snackbar('Error', 'Failed to load more food items');
    } finally {
      isFetchingMore.value = false;
    }
  }

  void setFilter(FoodCategory filter) {
    if (currentFilter.value == filter) return;
    currentFilter.value = filter;
    if (filter != FoodCategory.all) {
      searchController.clear();
      searchQuery.value = '';
    }
    _fetchInitialFoodItems();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isNotEmpty && currentFilter.value != FoodCategory.all) {
      currentFilter.value = FoodCategory.all;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchInitialFoodItems();
    });
  }
}
