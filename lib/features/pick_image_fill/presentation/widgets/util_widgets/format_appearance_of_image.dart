import 'package:flutter/material.dart';

class FormattedImage extends StatefulWidget {
  final Image image;
  final BoxConstraints? constraints;

  const FormattedImage({super.key, required this.image, this.constraints});

  @override
  _FormattedImageState createState() => _FormattedImageState();
}

class _FormattedImageState extends State<FormattedImage> {
  double? _imageWidth;
  double? _imageHeight;

  @override
  void initState() {
    super.initState();
    _resolveImageDimensions();
  }

  void _resolveImageDimensions() async {
    final ImageStream imageStream = widget.image.image.resolve(ImageConfiguration.empty);
    final ImageStreamListener listener = ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageWidth = info.image.width.toDouble();
        _imageHeight = info.image.height.toDouble();
      });
    });

    imageStream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    if (_imageWidth == null || _imageHeight == null) {
      // While the image is loading, you can return a placeholder or loading indicator
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      constraints: widget.constraints ??
          BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height * 0.1,
            minWidth: MediaQuery.sizeOf(context).width * 0.1,
            maxWidth: MediaQuery.sizeOf(context).width * 0.8,
            maxHeight: MediaQuery.sizeOf(context).height * 0.8,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: _imageWidth,
            height: _imageHeight,
            child: widget.image,
          ),
        ),
      ),
    );
  }
}
