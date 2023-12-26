import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:datingapp/src/app.dart';
void main() {
  runApp(const ProviderScope(child: DatingApp()));
}
