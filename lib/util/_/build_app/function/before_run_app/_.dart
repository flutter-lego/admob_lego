import 'package:flutter/material.dart';
import '../../../../../main.dart';
import 'widget_binding_lego/_.dart';
import 'admob_lego/_.dart';

Future<void> readyBeforeRunApp() async {
  if (_done) return;
  _done = true;
  await readyForWidgetBindingLego();
  await readyForAdmobLego();

}

bool _done = false;
