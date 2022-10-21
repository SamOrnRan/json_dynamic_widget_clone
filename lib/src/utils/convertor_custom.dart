import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConvertorCustome {
  static MapType? formDynamicMapType(dynamic map) {
    MapType? result;
    if (map != null) {
      switch (map) {
        case 'none':
          result = MapType.none;
          break;
        case 'satellite':
          result = MapType.satellite;
          break;
        case 'hybrid':
          result = MapType.hybrid;
          break;
        case 'normal':
          result = MapType.normal;
          break;
        case 'terrain':
          result = MapType.terrain;
          break;
        default:
          ;
      }
    }
    return result!;
  }
}
