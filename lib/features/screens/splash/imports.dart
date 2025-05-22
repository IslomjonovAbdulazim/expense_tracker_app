import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/adaptive_logo.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/brand_constants.dart';
import '../../../utils/extenstions/color_extension.dart';
import '../../../utils/extenstions/text_style_extention.dart';
import '../../../utils/helpers/app_diagnostics.dart';
import '../../../utils/helpers/logger.dart';
import '../../../utils/services/auth_service.dart';
import '../../../utils/services/connectivity_service.dart';
import '../../../utils/services/theme_service.dart';
import '../../../utils/services/token_service.dart';

part 'binding.dart';
part 'controller.dart';
part 'page.dart';
part 'widgets.dart';

