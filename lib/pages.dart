import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
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

import 'models/chat_home_item.dart';

part 'features/splash/splash_controller.dart';

part 'features/splash/splash_screen.dart';

part 'features/signin/signin_controlller.dart';

part 'features/signin/signin_screen.dart';

part 'features/navigation/navigation_controller.dart';

part 'features/navigation/navigation_screen.dart';

part 'features/widgets/button.dart';

part 'features/widgets/style_text.dart';

part 'features/widgets/divider.dart';

part 'features/widgets/action_circle.dart';

part 'features/widgets/profile_card.dart';

part 'features/widgets/stamp.dart';

part 'features/datting/datting_controller.dart';

part 'features/datting/datting_screen.dart';

part 'features/datting/swipe/swipe_deck.dart';

part 'features/datting/swipe/swipe_deck_controller.dart';

part 'features/datting/swipe/swipe_types.dart';

part 'features/chat/chat_list_controller.dart';

part 'features/chat/chat_list_screen.dart';

part 'features/chat/chat_room_controller.dart';

part 'features/chat/chat_room_screen.dart';

part 'features/chat/chat_home_controller.dart';

part 'features/chat/chat_home_screen.dart';

part 'features/me/me_controller.dart';

part 'features/me/me_screen.dart';

part 'core/theme.dart';

part 'core/utils.dart';

part 'core/auth_service.dart';

part 'models/model_navbar.dart';

part 'models/models_datting.dart';

part 'models/chat_message.dart';

part 'models/chat_room.dart';

part 'models/dating_user.dart';

part 'data/chat_repo.dart';

part 'data/user_repo.dart';
