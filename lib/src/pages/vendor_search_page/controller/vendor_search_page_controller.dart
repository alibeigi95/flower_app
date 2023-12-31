import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/grid_item.dart';
import '../../vendor_home_page/models/flower_list_view_model.dart';
import '../repositories/vendor_search_page_repository.dart';

class VendorSearchPageController extends GetxController {
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  final VendorSearchPageRepository _repository = VendorSearchPageRepository();
  List<String> savedSelections = [];
  final RxList<ColorGridItem> colorItems = RxList<ColorGridItem>([]);
  List<String> dropDownButtonList = ['select a item'];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');
  Rx<RangeValues> valuesRange = Rx<RangeValues>(const RangeValues(0, 1));
  RxList<FlowerListViewModel> filteredFlowerList = RxList();
  String vendorUserEmail = '';
  final TextEditingController searchController = TextEditingController();
  RxList<FlowerListViewModel> flowerList = RxList();
  RxBool isLoading = false.obs;
  List<int> priceList = [];
  double maxPrice = 2.0;
  final deBouncer = Debouncer(delay: const Duration(seconds: 1));

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _prefs = Get.find<SharedPreferences>();
    vendorUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getFlowerList();
    getColorList();
    getCategoryList();
  }

  Future<void> getFlowerList() async {
    showLoading();
    flowerList.clear();
    final result = await _repository.getFlowerList(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('get flower', 'flower not found');
    } else if (result.isRight) {
      flowerList.addAll(result.right);
      for (final item in result.right) {
        priceList.add(item.price);
      }
    }
    if (flowerList.isNotEmpty) {
      maxPrices();
    }
    hideLoading();
  }

  Future<void> getColorList() async {
    showLoading();
    colorItems.clear();
    final result = await _repository.getColorList();
    if (result.isLeft) {
      Get.snackbar('get color', 'color not found');
    } else if (result.isRight) {
      for (final item in result.right) {
        colorItems.add(ColorGridItem(color: Color(item.color)));
      }
    }
    hideLoading();
  }

  Future<void> getCategoryList() async {
    dropDownButtonList.clear();
    dropDownButtonList = ['select a item'];
    selectedItemDropDown = Rx<String>('select a item');
    final result = await _repository.getCategoryList();
    if (result.isLeft) {
      Get.snackbar('get category', 'category not found');
    } else if (result.isRight) {
      for (final item in result.right) {
        for (final categoryItem in item.category) {
          dropDownButtonList.add(categoryItem);
        }
      }
    }
  }

  void maxPrices() {
    priceList.sort();
    maxPrice = priceList.last.toDouble();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
  }

  RangeValues get values => valuesRange.value;

  void setValues({required RangeValues rangeValues}) {
    valuesRange.value = rangeValues;
  }

  void clearSearchFilterFlowers({required BuildContext context}) {
    filteredFlowerList.clear();
    searchController.clear();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
    filteredFlowerList.clear();
    selectedItemDropDown.value = 'select a item';
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = false;
    }
    List<String> selections =
        colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    colorItems.refresh();
    Navigator.of(context).pop();
  }

  void clearSearchFilterFlowersTextField() {
    filteredFlowerList.clear();
    searchController.clear();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
    filteredFlowerList.clear();
    selectedItemDropDown.value = 'select a item';
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = false;
    }
    List<String> selections =
        colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    colorItems.refresh();
  }

  Future<void> getSearchFilterFlowerList(
      {required BuildContext context}) async {
    filteredFlowerList.clear();
    Navigator.of(context).pop();
    showLoading();
    List<int> colorFilter = [];
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = savedSelections[i] == 'true';
      if (colorItems[i].isSelected) {
        colorFilter.add(colorItems[i].color.value);
      }
    }
    String colorFilters = colorFilter.map((color) => 'color=$color').join('&');
    if (selectedItemDropDown.value != 'select a item' && colorFilters != '') {
      _searchFilters(colorFilters: colorFilters);
    } else if (selectedItemDropDown.value != 'select a item') {
      _searchFilterCategoryPrice();
    } else if (colorFilters != '') {
      _searchFilterColorPrice(colorFilters: colorFilters);
    } else {
      _searchFilterPriceRange();
    }
    hideLoading();
  }

  Future<void> _searchFilters({required String colorFilters}) async {
    final searchFiltersResult = await _repository.searchFilters(
      category: selectedItemDropDown.value,
      email: vendorUserEmail,
      colors: colorFilters,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
    );
    if (searchFiltersResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (searchFiltersResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(searchFiltersResult.right);
      hideLoading();
    }
  }

  Future<void> _searchFilterCategoryPrice() async {
    final searchFiltersResult = await _repository.searchFilterCategoryPrice(
      category: selectedItemDropDown.value,
      email: vendorUserEmail,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
    );
    if (searchFiltersResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (searchFiltersResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(searchFiltersResult.right);
      hideLoading();
    }
  }

  Future<void> _searchFilterColorPrice({required String colorFilters}) async {
    final searchFiltersResult = await _repository.searchFilterColorPrice(
      email: vendorUserEmail,
      colors: colorFilters,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
    );
    if (searchFiltersResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (searchFiltersResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(searchFiltersResult.right);
      hideLoading();
    }
  }

  Future<void> _searchFilterPriceRange() async {
    final priceResult = await _repository.searchFilterPriceRange(
      email: vendorUserEmail,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
    );
    if (priceResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (priceResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(priceResult.right);
      hideLoading();
    }
  }

  Future<void> getSearchFlowerList({required String search}) async {
    deBouncer(() async {
      showLoading();
      List<int> colorFilter = [];
      for (int i = 0; i < savedSelections.length; i++) {
        colorItems[i].isSelected = savedSelections[i] == 'true';
        if (colorItems[i].isSelected) {
          colorFilter.add(colorItems[i].color.value);
        }
      }
      String colorFilters =
          colorFilter.map((color) => 'color=$color').join('&');

      if (selectedItemDropDown.value != 'select a item' && colorFilters != '') {
        _searchTextFieldWithFilters(search: search, colorFilters: colorFilters);
      } else if (selectedItemDropDown.value != 'select a item') {
        _searchTextFieldCategoryPrice(search: search);
      } else if (colorFilters != '') {
        _searchTextFieldColorPrice(search: search, colorFilters: colorFilters);
      } else {
        _textFieldSearchWithPriceRange(search: search);
      }
      hideLoading();
    });
  }

  Future<void> _searchTextFieldWithFilters(
      {required String search, required String colorFilters}) async {
    final searchFiltersResult = await _repository.searchTextFieldWithFilters(
      category: selectedItemDropDown.value,
      email: vendorUserEmail,
      colors: colorFilters,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
      search: search,
    );
    if (searchFiltersResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (searchFiltersResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(searchFiltersResult.right);
      hideLoading();
    }
  }

  Future<void> _searchTextFieldCategoryPrice({required String search}) async {
    final searchFiltersResult = await _repository.searchTextFieldCategoryPrice(
      category: selectedItemDropDown.value,
      email: vendorUserEmail,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
      search: search,
    );
    if (searchFiltersResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (searchFiltersResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(searchFiltersResult.right);
      hideLoading();
    }
  }

  Future<void> _searchTextFieldColorPrice(
      {required String search, required String colorFilters}) async {
    final searchFiltersResult = await _repository.searchTextFieldColorPrice(
      email: vendorUserEmail,
      colors: colorFilters,
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
      search: search,
    );
    if (searchFiltersResult.isLeft) {
      Get.snackbar('search', 'search result is error');
    } else if (searchFiltersResult.isRight) {
      filteredFlowerList.clear();
      filteredFlowerList.addAll(searchFiltersResult.right);
      hideLoading();
    }
  }

  Future<void> _textFieldSearchWithPriceRange({required String search}) async {
    if (search != '') {
      final result = await _repository.textFieldSearchWithPriceRange(
          email: vendorUserEmail,
          min: valuesRange.value.start.toString(),
          max: valuesRange.value.end.toString(),
          search: search);
      if (result.isLeft) {
        Get.snackbar('search', 'search result is error');
      } else if (result.isRight) {
        filteredFlowerList.clear();
        filteredFlowerList.addAll(result.right);
      }
    } else {
      filteredFlowerList.clear();
    }
  }

  void colorToggleSelection({required int colorToggleIndex}) {
    colorItems[colorToggleIndex].isSelected =
        !colorItems[colorToggleIndex].isSelected;
    List<String> selections =
        colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = savedSelections[i] == 'true';
      colorItems.refresh();
    }
  }
}
