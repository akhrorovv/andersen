import 'package:andersen/core/config/theme/app_colors.dart';
import 'package:andersen/features/tasks/presentation/widgets/task_update_field.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownField<T> extends StatelessWidget {
  final String title;
  final String iconPath;
  final Future<List<T>> Function(String? filter) items;
  final String Function(T item) itemAsString;
  final void Function(T? value) onChanged;
  final T? selectedItem;
  final bool Function(T, T)? compareFn;
  final bool? hasDivider;


  const CustomDropdownField({
    super.key,
    required this.title,
    required this.iconPath,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    this.selectedItem,
    this.compareFn,
    this.hasDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return TaskUpdateField(
      title: title,
      iconPath: iconPath,
      hasDivider: hasDivider,
      child: DropdownSearch<T>(
        items: (String? filter, props) => items(filter),
        selectedItem: selectedItem,
        compareFn: compareFn,
        itemAsString: itemAsString,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
            hintText: title,
            hintStyle: TextStyle(color: AppColors.black45),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
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
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
