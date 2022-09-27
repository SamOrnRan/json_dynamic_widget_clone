import 'package:json_theme/json_theme_schemas.dart';

class PlaceholderSchemaImage {
  static const id = 'https://your-url-here.com/schemas/placeholder_network';
  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': id,
    r'$comment': 'https://docs.flutter.dev/cookbook/images/fading-in-images',
    'type': 'object',
    'title': 'placeholder_network',
    'additionalProperties': false,
    'required': [
      'image',
    ],
    'properties': {
      'image': SchemaHelper.stringSchema,
      'placeholder': SchemaHelper.stringSchema,
      'boxFit': SchemaHelper.objectSchema(BoxFitSchema.id),
      'errorImage': SchemaHelper.stringSchema,
      'imageCacheHeight': SchemaHelper.numberSchema,
      'imageCacheWidth': SchemaHelper.numberSchema,
      'imageScale': SchemaHelper.numberSchema,
      'imageSemanticLabel': SchemaHelper.stringSchema,
      'excludeFromSemantics': SchemaHelper.boolSchema,
      'width': SchemaHelper.numberSchema,
      'height': SchemaHelper.numberSchema,
      'placeholderCacheHeight': SchemaHelper.numberSchema,
      'placeholderCacheWidth': SchemaHelper.numberSchema,
      'placeholderScale': SchemaHelper.numberSchema,
      'fadeInCurve': SchemaHelper.stringSchema,
      'fadeOutCurve': SchemaHelper.stringSchema,
      'fadeInDuration': SchemaHelper.numberSchema,
      'fadeOutDuration': SchemaHelper.numberSchema,
    }
  };
}
