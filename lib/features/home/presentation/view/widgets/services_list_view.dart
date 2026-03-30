import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/features/home/presentation/cubit/organization_cubit.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/service_item_skeleton.dart';
import 'package:smart_queue/features/home/presentation/view/widgets/services_item.dart';

class ServicesListView extends StatelessWidget {
  const ServicesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationsCubit, OrganizationState>(
      builder: (context, state) {
        if (state is OrganizationsLoading) {
          return SizedBox(
            height: 192,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return const ServicesItemSkeleton();
              },
            ),
          );
        }

        if (state is OrganizationsError) {
          return Center(child: Text(state.message));
        }

        if (state is OrganizationsLoaded) {
          return SizedBox(
            height: 192,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.organizations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final org = state.organizations[index];

                return ServicesItem(organization: org);
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
