import 'package:flutter/material.dart';
import '../../../../core/utils/web_image_helper.dart';

class BreedImageWidget extends StatelessWidget {
  final String imageUrl;
  final String breedName;
  final double? height;
  final double borderRadius;

  const BreedImageWidget({
    super.key,
    required this.imageUrl,
    required this.breedName,
    this.height,
    this.borderRadius = 18,
  });

  void _openFullScreen(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: true,
        barrierColor: Colors.black,
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenBreedImage(imageUrl: imageUrl, breedName: breedName);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasHeight = height != null;
    return Hero(
      tag: 'breed-image-$imageUrl',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: () => _openFullScreen(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: double.infinity,
              height: height,
              decoration: const BoxDecoration(color: Color(0xFFF3F6F4)),
              child: Stack(
                fit: hasHeight ? StackFit.expand : StackFit.loose,
                children: [
                  AppImage(
                    path: imageUrl,
                    width: double.infinity,
                    height: height,
                    fit: hasHeight ? BoxFit.contain : BoxFit.fitWidth,
                    alignment: Alignment.center,
                    filterQuality: FilterQuality.high,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      double? progress;
                      if (loadingProgress.expectedTotalBytes != null) {
                        progress =
                            loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!;
                      }

                      return Container(
                        height: height ?? 200,
                        color: const Color(0xFFF3F6F4),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 3,
                              color: const Color(0xFF1E7A46),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Loading image...',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: height ?? 200,
                        color: const Color(0xFFF3F6F4),
                        alignment: Alignment.center,
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: Colors.black38,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image not available',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Soft bottom gradient
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: 70,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Fullscreen icon
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.62),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.fullscreen_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'View',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FullScreenBreedImage extends StatefulWidget {
  final String imageUrl;
  final String breedName;

  const FullScreenBreedImage({
    super.key,
    required this.imageUrl,
    required this.breedName,
  });

  @override
  State<FullScreenBreedImage> createState() => _FullScreenBreedImageState();
}

class _FullScreenBreedImageState extends State<FullScreenBreedImage> {
  final TransformationController _transformationController =
      TransformationController();

  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _onDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _onDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale > 1.0) {
      _resetZoom();
      return;
    }

    final position = _doubleTapDetails?.localPosition;

    if (position == null) {
      return;
    }

    const scale = 2.5;

    final matrix = Matrix4.identity()
      ..translateByDouble(-position.dx * (scale - 1), -position.dy * (scale - 1), 0.0, 1.0)
      ..scaleByDouble(scale, scale, 1.0, 1.0);

    _transformationController.value = matrix;
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onDoubleTapDown: _onDoubleTapDown,
                onDoubleTap: _onDoubleTap,
                child: Center(
                  child: Hero(
                    tag: 'breed-image-${widget.imageUrl}',
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      minScale: 0.8,
                      maxScale: 5.0,
                      panEnabled: true,
                      scaleEnabled: true,
                      boundaryMargin: const EdgeInsets.all(100),
                      clipBehavior: Clip.none,
                      child: AppImage(
                        path: widget.imageUrl,
                        width: screenSize.width,
                        height: screenSize.height,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        filterQuality: FilterQuality.high,

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          double? progress;

                          if (loadingProgress.expectedTotalBytes != null) {
                            progress =
                                loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!;
                          }

                          return SizedBox(
                            width: screenSize.width,
                            height: screenSize.height,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 3,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) {
                          return SizedBox(
                            width: screenSize.width,
                            height: screenSize.height,
                            child: const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.broken_image_outlined,
                                    size: 64,
                                    color: Colors.white70,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Unable to load image',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Top gradient
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 100,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.75),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Close
            Positioned(
              top: 10,
              left: 10,
              child: _RoundButton(
                icon: Icons.close_rounded,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),

            // Reset zoom
            Positioned(
              top: 10,
              right: 10,
              child: _RoundButton(
                icon: Icons.refresh_rounded,
                onTap: _resetZoom,
              ),
            ),

            // Breed name
            Positioned(
              top: 20,
              left: 65,
              right: 65,
              child: Text(
                widget.breedName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // Bottom instruction
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.60),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.zoom_in_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Pinch or double tap to zoom',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.60),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
