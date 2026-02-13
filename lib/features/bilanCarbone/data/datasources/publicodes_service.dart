// Si on a accès à "dart:ffi" (Mobile/Desktop), on prend la version Mobile.
// Sinon (Web), on prend la version Web.
export 'publicodes_service_web.dart'
    if (dart.library.ffi) 'publicodes_service_mobile.dart';