import 'package:child_builder/child_builder.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:json_class/json_class.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:json_theme/json_theme.dart';
import 'package:pdfx/pdfx.dart';

class JsonPdfViewBuilder extends JsonWidgetBuilder {
  JsonPdfViewBuilder(
      {this.fromUrl,
      this.fromAsset,
      this.backgroundDecoration,
      this.pageSnapping,
      this.physics,
      this.scrollDirection})
      : super(numSupportedChildren: kNumSupportedChildren);
  static const kNumSupportedChildren = 1;
  static const type = 'pdf_view';
  final String? fromUrl;
  final String? fromAsset;
  final bool? pageSnapping;
  final Axis? scrollDirection;
  final ScrollPhysics? physics;
  final BoxDecoration? backgroundDecoration;
  static JsonPdfViewBuilder? fromDynamic(dynamic map,
      {JsonWidgetRegistry? registry}) {
    JsonPdfViewBuilder? resultPdf;
    if (map != null) {
      resultPdf = JsonPdfViewBuilder(
          fromAsset: map['fromAsset'] ?? '',
          fromUrl: map['fromUrl'] ?? '',
          pageSnapping: JsonClass.parseBool(map['pageSnapping']),
          physics: ThemeDecoder.decodeScrollPhysics(map['physics']),
          scrollDirection: ThemeDecoder.decodeAxis(map['scrollDirection']),
          backgroundDecoration:
              ThemeDecoder.decodeBoxDecoration(map['backgroundDecoration']));
    }
    return resultPdf;
  }

  @override
  Widget buildCustom(
      {ChildWidgetBuilder? childBuilder,
      required BuildContext context,
      required JsonWidgetData data,
      Key? key}) {
    return WidgetPdfView(
      data: data,
      childBuilder: childBuilder,
      newFromAsset: fromAsset,
      newFromUrl: fromUrl,
      valuePageSnapping: pageSnapping,
      valueScrollDirection: scrollDirection,
      valueScrollPhysics: physics,
      valueBackgroundDecoration: backgroundDecoration,
    );
  }
}

class WidgetPdfView extends StatefulWidget {
  const WidgetPdfView({
    this.childBuilder,
    required this.data,
    this.newFromAsset,
    this.newFromUrl,
    this.valuePageSnapping,
    this.valueScrollDirection,
    this.valueScrollPhysics,
    this.valueBackgroundDecoration,
    Key? key,
  }) : super(key: key);
  final JsonWidgetData data;
  final ChildWidgetBuilder? childBuilder;
  final String? newFromUrl;
  final String? newFromAsset;
  final Axis? valueScrollDirection;
  final ScrollPhysics? valueScrollPhysics;
  final bool? valuePageSnapping;
  final BoxDecoration? valueBackgroundDecoration;

  @override
  State<WidgetPdfView> createState() => _PdfWidgetViewState();
}

class _PdfWidgetViewState extends State<WidgetPdfView> {
  late PdfController controller;
  String valueUrl = "";
  String valueAsset = "";
  @override
  void initState() {
    valueAsset = widget.newFromAsset ?? "";
    valueUrl = widget.newFromUrl ?? "";
    if (valueAsset.isNotEmpty) {
      _initAsset();
    } else if (valueUrl.isNotEmpty) {
      _initUrl();
    }

    super.initState();
  }

  void _initUrl() {
    controller = PdfController(
        document: PdfDocument.openData(InternetFile.get(valueUrl)));
  }

  void _initAsset() async {
    controller = PdfController(document: PdfDocument.openAsset(valueAsset));
  }

  @override
  Widget build(BuildContext context) {
    return PdfView(
      controller: controller,
      scrollDirection: widget.valueScrollDirection ?? Axis.vertical,
      pageSnapping: widget.valuePageSnapping ?? true,
      physics: widget.valueScrollPhysics,
      backgroundDecoration: widget.valueBackgroundDecoration ??
          const BoxDecoration(color: Colors.white),
      builders: PdfViewBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(
          loaderSwitchDuration: Duration(milliseconds: 200),
          transitionBuilder: CatchProblemsPdf.transitionBuilder,
        ),
        documentLoaderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
        errorBuilder: (_, error) => Center(child: Text(error.toString())),
        pageBuilder: CatchProblemsPdf.pageBuilder,
        pageLoaderBuilder: (_) =>
            const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// Need static methods for builders arguments
class CatchProblemsPdf {
  static Widget builder(
    BuildContext context,
    PdfViewPinchBuilders builders,
    PdfLoadingState state,
    WidgetBuilder loadedBuilder,
    PdfDocument? document,
    Exception? loadingError,
  ) {
    final Widget content = () {
      switch (state) {
        case PdfLoadingState.loading:
          return KeyedSubtree(
            key: const Key('pdfx.root.loading'),
            child: builders.documentLoaderBuilder?.call(context) ??
                const SizedBox(),
          );
        case PdfLoadingState.error:
          return KeyedSubtree(
            key: const Key('pdfx.root.error'),
            child: builders.errorBuilder?.call(context, loadingError!) ??
                Center(child: Text(loadingError.toString())),
          );
        case PdfLoadingState.success:
          return KeyedSubtree(
            key: Key('pdfx.root.success.${document!.id}'),
            child: loadedBuilder(context),
          );
      }
    }();

    final defaultBuilder =
        builders as PdfViewPinchBuilders<DefaultBuilderOptions>;
    final options = defaultBuilder.options;

    return AnimatedSwitcher(
      duration: options.loaderSwitchDuration,
      transitionBuilder: options.transitionBuilder,
      child: content,
    );
  }

  static Widget transitionBuilder(Widget child, Animation<double> animation) =>
      FadeTransition(opacity: animation, child: child);

  static PhotoViewGalleryPageOptions pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) =>
      PhotoViewGalleryPageOptions(
        imageProvider: PdfPageImageProvider(
          pageImage,
          index,
          document.id,
        ),
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.contained * 3.0,
        initialScale: PhotoViewComputedScale.contained * 1.0,
        heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
      );
}
