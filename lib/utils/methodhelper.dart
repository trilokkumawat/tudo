import 'package:flutter/material.dart';

void safeSetState(State state, VoidCallback fn) {
  if (state.mounted) {
    // ignore: invalid_use_of_protected_member
    state.setState(fn);
  }
}
