import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supercharged/supercharged.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'models/chat_home_item.dart';

part 'features/splash/splash_controller.dart';

part 'features/splash/splash_screen.dart';

part 'features/signin/signin_controlller.dart';

part 'features/signin/signin_screen.dart';

part 'features/blocked_users/blocker_users_controller.dart';

part 'features/blocked_users/blocker_users_screen.dart';

part 'features/notification/notification_controller.dart';

part 'features/notification/notification_screen.dart';

part 'features/subscription/subscription_controller.dart';

part 'features/subscription/subscription_screen.dart';

part 'features/connected_account/connected_account_controller.dart';

part 'features/connected_account/connected_account_screen.dart';

part 'features/navigation/navigation_controller.dart';

part 'features/navigation/navigation_screen.dart';

part 'features/widgets/button.dart';

part 'features/widgets/style_text.dart';

part 'features/widgets/divider.dart';
part 'features/widgets/geolocator.dart';

part 'features/widgets/toggle.dart';

part 'features/widgets/action_circle.dart';

part 'features/widgets/text_field.dart';

part 'features/widgets/dialog.dart';

part 'features/widgets/profile_card.dart';

part 'features/widgets/stamp.dart';

part 'features/widgets/image_picker.dart';

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

part 'features/edit_profile/edit_profile_controller.dart';

part 'features/edit_profile/edit_profile_screen.dart';

part 'features/edit_profile/widgets/glass_header.dart';

part 'features/edit_profile/widgets/section_card.dart';

part 'features/edit_profile/widgets/prompt_box.dart';

part 'features/edit_profile/widgets/slider_row.dart';

part 'features/edit_profile/widgets/mini_note.dart';

part 'features/edit_profile/widgets/chip_editor.dart';

part 'features/edit_profile/widgets/photo_grid.dart';

part 'core/theme.dart';

part 'core/utils.dart';

part 'core/auth_service.dart';

part 'core/app_log.dart';

part 'models/model_navbar.dart';

part 'models/models_datting.dart';

part 'models/chat_message.dart';

part 'models/chat_room.dart';

part 'models/dating_user.dart';

part 'data/chat_repo.dart';

part 'data/user_repo.dart';
