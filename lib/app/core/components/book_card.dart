import 'package:flutter/material.dart';
import 'package:vitrine_ufma/app/core/components/accessible_network_image_zoom.dart';
import 'package:vitrine_ufma/app/core/components/text_widget.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 250,
            width: 150,
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
      constraints: const BoxConstraints(maxWidth: 150),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 160,
                  width: 120,
                  decoration: BoxDecoration(
                    color: AppColors.mediumGrey,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AccessibleNetworkImageZoom(
                    imageUrl: book.coverImage,
                    altText: 'Capa do livro ${book.title}',
                    width: 120,
                    height: 160,
                    fit: BoxFit.cover,
                    enableVLibras: true,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Return a placeholder image or a custom error widget
                      return Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                TextWidget(
                  text: book.title,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                TextWidget(
                  text: "Autor: ${book.author.join(", ")}",
                  maxLines: 2,
                  fontSize: 12,
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}