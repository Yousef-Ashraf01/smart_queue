import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_queue/core/constants/app_assets.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key}); // ✔ super parameter

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4,
            offset: Offset(-4, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(AppAssets.imageLogoBook, width: 60, height: 60),
              SizedBox(width: 7),
              Text(
                "Salah tarek",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Image.asset(AppAssets.imagePersonal, width: 60, height: 60),
            ],
          ),
          SizedBox(height: 4),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Service: ",
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "Extracting a savings book",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              SvgPicture.asset(
                AppAssets.iconLocation,
                fit: BoxFit.cover,
                height: 22,
                width: 22,
                color: Color(0xFF2ECC71),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your address",
                    style: TextStyle(fontSize: 12, color: Color(0xFF898EBC)),
                  ),
                  Text("Helwan, Cairo, Egypt", style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
