import 'package:json_theme/json_theme_schemas.dart';

class CarouselSchema {
  static const id =
      'https://peiffer-innovations.github.io/flutter_json_schemas/schemas/json_dynamic_widget/carousel_slider';
  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': id,
    'title': 'carouselSlider',
    'oneOf': [
      {
        'type': 'null',
      },
      {
        'type': 'object',
        'additionalProperties': false,
        'properties': {
          'aspect_ratio': SchemaHelper.numberSchema,
          'height': SchemaHelper.numberSchema,
          'initial_page': SchemaHelper.numberSchema,
          'itemCount': SchemaHelper.numberSchema,
          'scrollDirection': SchemaHelper.objectSchema(AxisSchema.id),
          'autoPlay': SchemaHelper.boolSchema,
          'reverse': SchemaHelper.boolSchema,
          'enableInfiniteScroll': SchemaHelper.boolSchema,
          'autoPlayInterval': SchemaHelper.numberSchema,
          'autoPlayAnimationDuration': SchemaHelper.numberSchema,
          'autoPlayCurve': SchemaHelper.numberSchema,
          'scrollPhysics': SchemaHelper.objectSchema(ScrollPhysicsSchema.id),
          'pageSnapping': SchemaHelper.boolSchema,
          'pauseAutoPlayInFiniteScroll': SchemaHelper.boolSchema,
          'pauseAutoPlayOnManualNavigate': SchemaHelper.boolSchema,
          'pauseAutoPlayOnTouch': SchemaHelper.boolSchema,
          'padEnds': SchemaHelper.boolSchema,
          'enlargeCenterPage': SchemaHelper.boolSchema,
          'viewportFraction': SchemaHelper.numberSchema,
          'clipBehavior': SchemaHelper.objectSchema(ClipSchema.id),
          'controller': SchemaHelper.stringSchema,
        }
      }
    ]
  };
}
