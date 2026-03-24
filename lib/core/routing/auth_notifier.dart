import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:smart_queue/features/auth/presentaion/cubit/auth_cubit.dart';

class AuthNotifier extends ChangeNotifier {
  final AuthCubit cubit;
  late final StreamSubscription _subscription;

  AuthNotifier(this.cubit) {
    _subscription = cubit.stream.listen((_) {
      notifyListeners();
    });
  }

  bool get isLoggedIn => cubit.state is LoginSuccess;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
