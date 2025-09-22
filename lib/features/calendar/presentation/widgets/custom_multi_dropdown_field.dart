import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMultiDropdownField<T> extends StatelessWidget {
  final String? hint;
  final Future<List<T>> Function(String? filter) items;
  final String Function(T item) itemAsString;
  final void Function(List<T> values) onChanged;
  final List<T> selectedItems;
  final bool Function(T, T)? compareFn;

  const CustomMultiDropdownField({
    super.key,
    this.hint,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    required this.selectedItems,
    this.compareFn,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>.multiSelection(
      items: (String? filter, _) => items(filter),
      selectedItems: selectedItems,
      compareFn: compareFn,
      itemAsString: itemAsString,
      dropdownBuilder: (context, selectedList) {
        if (selectedList.isEmpty) {
          return Text(
            hint ?? '',
            style: TextStyle(color: AppColors.black45, fontSize: 14.sp),
          );
        }

        return Wrap(
          spacing: 4.w,
          children: selectedList
              .map((e) => Chip(
            label: Text(
              itemAsString(e),
              style: TextStyle(
                color: AppColors.colorText,
                fontSize: 12.sp,
              ),
            ),
            backgroundColor: AppColors.colorPrimaryBg,
          ))
              .toList(),
        );
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          hintStyle: TextStyle(color: AppColors.black45),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.dividerColor),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
      popupProps: PopupPropsMultiSelection.menu(
        fit: FlexFit.loose,
        showSearchBox: true,
        showSelectedItems: true,
        menuProps: MenuProps(
          backgroundColor: AppColors.background,
          borderRadius: BorderRadius.circular(8.r),
        ),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: "Search...",
            contentPadding: EdgeInsets.zero,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.dividerColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
