import 'package:flutter/material.dart';
import 'package:oikos/init_dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:oikos/core/logger.dart';

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  // On s'assure que la String commence par FF (opacité) et ne contient pas de #
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class StorageUtils {
  static String getNetworkUrl(String bucket, String path) {

    final String netWorkUrl = serviceLocator<SupabaseClient>(instanceName: 'supabaseExternal')
        .storage
        .from(bucket)
        .getPublicUrl(path.trim());

    return netWorkUrl;
  }

  static String getLocalUrl(String bucket, String path) {

    final String getLocalUrl = "assets/$bucket/${path.trim()}";


    return getLocalUrl;
  }


}


extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

