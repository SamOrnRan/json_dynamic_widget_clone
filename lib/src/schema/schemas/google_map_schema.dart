import 'package:json_theme/json_theme_schemas.dart';

class GoogleMapSchema {
  static const id =
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_widget/google_map';
  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': id,
    r'$comment': 'https://pub.dev/packages/google_maps_flutter',
    'type': 'object',
    'title': 'GoogleMap',
    'additionalProperties': false,
    'required': [],
    'properties': {
      'zoom': SchemaHelper.numberSchema,
      'mapType': SchemaHelper.anySchema,
      'compassEnabled': SchemaHelper.boolSchema,
      'latLng': SchemaHelper.anySchema,
      'mapToolbarEnabled': SchemaHelper.boolSchema,
      'rotateGesturesEnabled': SchemaHelper.boolSchema,
      'scrollGesturesEnabled': SchemaHelper.boolSchema,
      'zoomControlsEnabled': SchemaHelper.boolSchema,
      'zoomGesturesEnabled': SchemaHelper.boolSchema,
      'liteModeEnabled': SchemaHelper.boolSchema,
      'tiltGesturesEnabled': SchemaHelper.boolSchema,
      'myLocationEnabled': SchemaHelper.boolSchema,
      'myLocationButtonEnabled': SchemaHelper.boolSchema,
      'layoutDirection': SchemaHelper.objectSchema(TextDecorationSchema.id),
      'padding': SchemaHelper.objectSchema(EdgeInsetsGeometrySchema.id),
      'indoorViewEnabled': SchemaHelper.boolSchema,
      'buildingsEnabled': SchemaHelper.boolSchema,
      'marker': SchemaHelper.anySchema,
    }
  };
}
