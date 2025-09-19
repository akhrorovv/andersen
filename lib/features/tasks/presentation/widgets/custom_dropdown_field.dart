import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String? hint;
  final Future<List<T>> Function(String? filter) items;
  final String Function(T item) itemAsString;
  final void Function(T? value) onChanged;
  final T? selectedItem;
  final bool Function(T, T)? compareFn;

  const CustomDropdownField({
    super.key,
    this.hint,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.selectedItem,
    this.compareFn,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: (String? filter, props) => items(filter),
      selectedItem: selectedItem,
      compareFn: compareFn,
      itemAsString: itemAsString,
      dropdownBuilder: (context, T? selectedItem) {
        if (selectedItem == null) {
          return Text(
            hint ?? '',
            style: TextStyle(color: AppColors.black45, fontSize: 14.sp),
          );
        }

        return Text(
          itemAsString(selectedItem),
          style: TextStyle(
            color: AppColors.colorText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        );
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
          // hintText: (hint != null) ? hint : null,
          hintStyle: TextStyle(color: AppColors.black45),
          enabledBorder: UnderlineInputBorder(
            // borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.dividerColor),
          ),
          focusedBorder: UnderlineInputBorder(
            // borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
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
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
