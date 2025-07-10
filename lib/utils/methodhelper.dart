import 'package:flutter/material.dart';

void safeSetState(State state, VoidCallback fn) {
  if (state.mounted) {
    state.setState(fn);
  }
}
