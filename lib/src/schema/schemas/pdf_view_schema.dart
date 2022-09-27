import 'package:json_theme/json_theme_schemas.dart';

class PdfViewSchema {
  static const id = 'https://your-url-here.com/schemas/pdf_view';
  static final schema = {
    r'$schema': 'http://json-schema.org/draft-06/schema#',
    r'$id': id,
    r'$comment': 'https://pub.dev/packages/pdfx',
    'type': 'object',
    'title': 'pdf_view',
    'additionalProperties': false,
    'required': [],
    'properties': {
      'fromAsset': SchemaHelper.stringSchema,
      'fromUrl': SchemaHelper.stringSchema,
      'pageSnapping': SchemaHelper.boolSchema,
      'physics': SchemaHelper.objectSchema(ScrollPhysicsSchema.id),
      'scrollDirection': SchemaHelper.objectSchema(AxisSchema.id),
      'backgroundDecoration': SchemaHelper.objectSchema(BoxDecorationSchema.id)
    }
  };
}
