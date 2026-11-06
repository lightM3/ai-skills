#!/usr/bin/env bash
set -e
mkdir -p lib
cat > pubspec.yaml <<'Y'
name: old_app
publish_to: none
environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"
dependencies:
  flutter:
    sdk: flutter
Y
cat > lib/main.dart <<'D'
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: Text('hi'))));
D
