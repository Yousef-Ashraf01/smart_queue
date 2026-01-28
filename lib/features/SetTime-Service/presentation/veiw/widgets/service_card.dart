import 'package:flutter/material.dart';

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
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF2ECC71), width: 2),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/b8016935c8f612b88435ec703a7bd7e49d662a8a.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 7),
              Text(
                "Salah tarek",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Spacer(),
              Image.asset(
                'assets/images/ac4851ebdc4b817d026c08c6ff00a0f68b5119a0.png',
                width: 60,
                height: 60,
              ),
            ],
          ),
          SizedBox(height: 4),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ": الخدمه",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 1),
                  Text(
                    "استخراج دفتر توفير",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFF2ECC71), size: 22),
              SizedBox(width: 8),
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
