import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class ImageSection extends StatelessWidget {
  final List<String> images;

  const ImageSection({
    Key? key,
    required this.images,
    
  }) : super(key: key);

  void _showImageGallery(
    BuildContext context,
    List<String> images,
    int initialIndex,
  ) {
    PageController pageController = PageController(initialPage: initialIndex);

    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.black,
            insetPadding: EdgeInsets.zero,
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return InteractiveViewer(
                      child: Image.network(
                        images[index],
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              FluentIcons.image_off_20_filled,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 30,
                  right: 20,
                  child: IconButton(
                    icon: Icon(FluentIcons.dismiss_20_filled, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return SizedBox.shrink(); // return empty if no images
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          'image'.tr(),
          style: GoogleFonts.figtree(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 140,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              final imageUrl = images[index];
              return GestureDetector(
                onTap: () => _showImageGallery(context, images, index),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
