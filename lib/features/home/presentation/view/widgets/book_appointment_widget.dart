import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

class BookAppointmentWidget extends StatelessWidget {
  const BookAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 21),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 6),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    AppAssets.imageLogoBook,
                    width: 55,
                    height: 62,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      Text(
                        "Yousef Ashraf",
                        style: AppStyle.bold16black.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Savings Account Passbook Issuance",
                        style: AppStyle.medium14gray.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 11,
                          color: Color(0xff898EBC),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Image.asset(
                AppAssets.imagePersonal,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ],
          ),
          SizedBox(height: 15),
          Text("National Postal Authority", style: AppStyle.bold16black),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconLocationAppointment,
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your address",
                            style: AppStyle.medium14gray.copyWith(
                              color: const Color(0xff898EBC),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            "Zagazig , Sharqia, Egypt",
                            style: AppStyle.bold16black,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AppAssets.iconClock,
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Remaining time for you",
                            style: AppStyle.medium14gray.copyWith(
                              color: const Color(0xff898EBC),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text("15 minutes", style: AppStyle.bold16black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
