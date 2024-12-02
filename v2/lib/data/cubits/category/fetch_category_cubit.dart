// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:eClassify/Utils/helper_utils.dart';
import 'package:eClassify/data/Repositories/category_repository.dart';
import 'package:eClassify/data/model/category_model.dart';
import 'package:eClassify/data/model/data_output.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

abstract class FetchCategoryState {}

class FetchCategoryInitial extends FetchCategoryState {}

class FetchCategoryInProgress extends FetchCategoryState {}

class FetchCategorySuccess extends FetchCategoryState {
  final int total;
  final int page;
  final bool isLoadingMore;
  final bool hasError;
  final List<CategoryModel> categories;
  final List<CategoryModel> categoriesSearch;

  FetchCategorySuccess({
    required this.total,
    required this.page,
    required this.isLoadingMore,
    required this.hasError,
    required this.categories,
    required this.categoriesSearch,
  });

  FetchCategorySuccess copyWith({
    int? total,
    int? page,
    bool? isLoadingMore,
    bool? hasError,
    List<CategoryModel>? categories,
    List<CategoryModel>? categoriesSearch,
  }) {
    return FetchCategorySuccess(
      total: total ?? this.total,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      categories: categories ?? this.categories,
      categoriesSearch: categoriesSearch ?? this.categoriesSearch,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      ' page': page,
      'isLoadingMore': isLoadingMore,
      'hasError': hasError,
      'categories': categories.map((x) => x.toJson()).toList(),
      'categoriesSearch': categoriesSearch.map((x) => x.toJson()).toList(),
    };
  }

  factory FetchCategorySuccess.fromMap(Map<String, dynamic> map) {
    return FetchCategorySuccess(
      total: map['total'] as int,
      page: map[' page'] as int,
      isLoadingMore: map['isLoadingMore'] as bool,
      hasError: map['hasError'] as bool,
      categories: List<CategoryModel>.from(
        (map['categories']).map<CategoryModel>(
          (x) => CategoryModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      categoriesSearch: List<CategoryModel>.from(
        (map['categories']).map<CategoryModel>(
          (x) => CategoryModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory FetchCategorySuccess.fromJson(String source) => FetchCategorySuccess.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FetchCategorySuccess(total: $total,  page: $page, isLoadingMore: $isLoadingMore, hasError: $hasError, categories: $categories)';
  }
}

class FetchCategoryFailure extends FetchCategoryState {
  final String errorMessage;

  FetchCategoryFailure(this.errorMessage);
}

class FetchCategoryCubit extends Cubit<FetchCategoryState> with HydratedMixin {
  FetchCategoryCubit() : super(FetchCategoryInitial());

  final CategoryRepository _categoryRepository = CategoryRepository();

  Future<void> fetchCategories({bool? forceRefresh, bool? loadWithoutDelay}) async {
    try {
      emit(FetchCategoryInProgress());

      DataOutput<CategoryModel> categories = await _categoryRepository.fetchCategories(page: 1);

      emit(FetchCategorySuccess(total: categories.total, categories: categories.modelList, categoriesSearch: categories.modelList, page: 1, hasError: false, isLoadingMore: false));
    } catch (e) {
      emit(FetchCategoryFailure(e.toString()));
    }
  }

  List<CategoryModel> getCategories() {
    if (state is FetchCategorySuccess) {
      return (state as FetchCategorySuccess).categories;
    }

    return <CategoryModel>[];
  }

  Future<void> fetchCategoriesMore() async {
    try {
      if (state is FetchCategorySuccess) {
        if ((state as FetchCategorySuccess).isLoadingMore) {
          return;
        }
        emit((state as FetchCategorySuccess).copyWith(isLoadingMore: true));
        DataOutput<CategoryModel> result = await _categoryRepository.fetchCategories(
          page: (state as FetchCategorySuccess).page + 1,
        );

        FetchCategorySuccess categoryState = (state as FetchCategorySuccess);
        categoryState.categories.addAll(result.modelList);

        List<String> list = categoryState.categories.map((e) => e.url!).toList();
        await HelperUtils.precacheSVG(list);

        emit(FetchCategorySuccess(
            isLoadingMore: false,
            hasError: false,
            categories: categoryState.categories,
            categoriesSearch: categoryState.categories,
            page: (state as FetchCategorySuccess).page + 1,
            total: result.total));
      }
    } catch (e) {
      emit((state as FetchCategorySuccess).copyWith(isLoadingMore: false, hasError: true));
    }
  }

  bool hasMoreData() {
    if (state is FetchCategorySuccess) {
      return (state as FetchCategorySuccess).categories.length < (state as FetchCategorySuccess).total;
    }
    return false;
  }

  void searchData(String query) {
    if (query != '') {
      FetchCategorySuccess categoryState = (state as FetchCategorySuccess);
      List<CategoryModel> filterCategories = [];
      filterCategories = categoryState.categoriesSearch.where((category) {
        // Pencarian pada nama kategori
        bool matchesCategoryName = (category.name ?? '').toLowerCase().contains(query);

        // Pencarian pada subcategories->name
        bool matchesSubcategoryName = category.children!.any((subcategory) => subcategory.name!.toLowerCase().contains(query));
        print("hahaha $matchesSubcategoryName");
        return matchesCategoryName || matchesSubcategoryName;
      }).toList();
      emit((state as FetchCategorySuccess).copyWith(categoriesSearch: filterCategories));
    } else {
      FetchCategorySuccess categoryState = (state as FetchCategorySuccess);
      List<CategoryModel> filterCategories = categoryState.categories;
      emit((state as FetchCategorySuccess).copyWith(categoriesSearch: filterCategories));
    }
  }

  @override
  FetchCategoryState? fromJson(Map<String, dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic>? toJson(FetchCategoryState state) {
    return null;
  }
}
