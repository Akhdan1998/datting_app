import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supercharged/supercharged.dart';
import 'package:google_fonts/google_fonts.dart';

part 'features/splash/splash_controller.dart';

part 'features/splash/splash_screen.dart';

part 'features/signin/signin_controlller.dart';

part 'features/signin/signin_screen.dart';

part 'features/navigation/navigation_controller.dart';

part 'features/navigation/navigation_screen.dart';

part 'features/widgets/button.dart';

part 'features/widgets/style_text.dart';
part 'features/widgets/divider.dart';

part 'features/datting/datting_controller.dart';

part 'features/datting/datting_screen.dart';

part 'features/chat/chat_controller.dart';

part 'features/chat/chat_screen.dart';

part 'features/me/me_controller.dart';

part 'features/me/me_screen.dart';

part 'core/theme.dart';

part 'core/utils.dart';

part 'core/auth_service.dart';

part 'models/model_navbar.dart';

part 'models/models_datting.dart';
