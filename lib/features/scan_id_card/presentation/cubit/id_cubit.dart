import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/features/scan_id_card/data/models/id_extract_model.dart';
import 'package:smart_queue/features/scan_id_card/data/repositories/id_repository.dart';

part 'id_state.dart';

class IdCubit extends Cubit<IdState> {
  final IdRepository repository;

  IdCubit(this.repository) : super(IdInitial());

  Future<void> extractId(File image) async {
    emit(IdLoading());

    final result = await repository.extractId(image);

    result.fold(
      (failure) => emit(IdError(failure.message)),
      (data) => emit(IdSuccess(data)),
    );
  }
}
