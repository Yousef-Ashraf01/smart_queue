import 'package:flutter/cupertino.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/book_appointment_widget.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/home_app_bar.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/search_text_field.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/services_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
            ),
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeAppBar(),
              SizedBox(height: 23),
              SearchTextField(),
              SizedBox(height: 23),
              Text("Most popular services", style: AppStyle.bold16black),
              SizedBox(height: 23),
              ServicesListView(),
              SizedBox(height: 23),
              Text("Booking appointment", style: AppStyle.bold16black),
              SizedBox(height: 25),
              BookAppointmentWidget(),
            ],
          ),
        ),
      ],
    );
  }
}
