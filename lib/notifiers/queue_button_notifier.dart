import 'package:flutter/material.dart';

class QueueButtonNotifier extends ValueNotifier<QueueState> {
  QueueButtonNotifier() : super(_initialValue);
  static const _initialValue = QueueState.inactive;
}

enum QueueState {
  inactive,
  active,
}
