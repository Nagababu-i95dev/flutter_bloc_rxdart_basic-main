import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Constants {
  Constants._();
  static const String BASE_URL =
      'https://github.com/mehrdad-shokri/feather';

  static const double ICON_SMALL_SIZE = 18;
  static const double ICON_MEDIUM_SIZE = 24;
  static const double ICON_LARGE_SIZE = 32;
  static const double CAPTION_FONT_SIZE = 12;
  static const double S2_FONT_SIZE = 14;
  static const double S1_FONT_SIZE = 16;
  static const double H6_FONT_SIZE = 18;
  static const double H5_FONT_SIZE = 21;
  static const double H4_FONT_SIZE = 24;
  static const double H3_FONT_SIZE = 28;
  static const double H2_FONT_SIZE = 31;
  static const double H1_FONT_SIZE = 34;
  static const FontWeight REGULAR_FONT_WEIGHT = FontWeight.w400;
  static const FontWeight MEDIUM_FONT_WEIGHT = FontWeight.w500;
  static const FontWeight BOLD_FONT_WEIGHT = FontWeight.bold;
  static const String APPLICATION_DEFAULT_FONT = 'Roboto';
  static const List<String> APPLICATION_FALLBACK_FONTS = ['sans-serif'];
  static const EdgeInsets PAGE_PADDING = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets CARD_INNER_PADDING =
  EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static final ShapeBorder CARD_SHAPE =
  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));
}