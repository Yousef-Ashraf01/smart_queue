import 'package:flutter/cupertino.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CupertinoSearchTextField(
        cursorColor: Color(0xff3CC572),
        placeholder: "Search for a specific service",
        backgroundColor: AppColors.whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
