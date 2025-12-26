import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

class ServicesListView extends StatelessWidget {
  const ServicesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 192,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            width: 121,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.09),
                  offset: const Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              color: AppColors.whiteColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.whiteColor,
                  child: Image.asset(AppAssets.imagePostal, fit: BoxFit.cover),
                ),
                SizedBox(height: 15),
                Text("National Postal Authority", style: AppStyle.bold16black),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xff3CC572)),
                    alignment: Alignment.center,
                    minimumSize: Size(91, 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Book", style: AppStyle.regular14black),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
