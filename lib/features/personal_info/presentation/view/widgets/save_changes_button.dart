import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';
import 'package:smart_queue/features/personal_info/presentation/view/widgets/app_button.dart';

class SaveChangesButton extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController idController;
  final TextEditingController phoneController;
  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final String countryCode;
  final XFile? pickedImage;

  const SaveChangesButton({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.idController,
    required this.phoneController,
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.countryCode,
    required this.pickedImage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
      builder: (context, state) {
        final isLoading = state is PersonalInfoUpdating;
        return Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 25),
          child: AppButton(
            text: "Save Changes",
            isLoading: isLoading,
            backgroundColor: const Color(0xFF00BFA6),
            onPressed: isLoading ? null : () => _onSave(context, state),
          ),
        );
      },
    );
  }

  void _onSave(BuildContext context, PersonalInfoState state) {
    if (state is! PersonalInfoLoaded) return;

    final birthDate = DateTime(
      int.parse(yearController.text),
      int.parse(monthController.text),
      int.parse(dayController.text),
    );

    final formattedDate = DateFormat('yyyy-MM-dd').format(birthDate);

    final updatedProfile = ProfileModel(
      id: state.profile.id,
      username: nameController.text,
      email: emailController.text,
      client: ClientRequestModel(
        nationalId: idController.text,
        birthDate: formattedDate,
        profession: "string",
        gender: "F",
        phone: "+$countryCode${phoneController.text}",
        imageFile: pickedImage,
      ),
    );

    context.read<PersonalInfoCubit>().updateProfile(updatedProfile);
  }
}
