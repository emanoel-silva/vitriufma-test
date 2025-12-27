import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/core/components/accessible_network_image_zoom.dart';
import 'package:vitrine_ufma/app/core/components/text_widget.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';

class FilteredBookCard extends StatelessWidget {
  final Book book;
  const FilteredBookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // controller.selectedBook = book;
       Modular.to.pushNamed('/home/books/${book.id}', arguments: book);
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 150),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextWidget(
                      text: book.author.length > 1
                          ? 'Autor: ${book.author[0]} e outros'
                          : 'Autor: ${book.author[0]}',
                      maxLines: 2,
                      fontSize: 12,
                    ),
                    TextWidget(
                      text: "Título: ${book.title}",
                      fontSize: 12,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: List.generate(
                          5,
                          (index) => Icon(
                                Icons.star,
                                color: index < 3
                                    ? AppColors.yellow
                                    : AppColors.mediumGrey,
                              )),
                    )
                  ],
                )),

            //Imagem do livro
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 160,
                width: 120,
                decoration: BoxDecoration(
                  color: AppColors.mediumGrey,
                  borderRadius: BorderRadius.circular(5),
                ),
                clipBehavior: Clip.antiAlias,
                child: AccessibleNetworkImageZoom(
                  imageUrl: book.coverImage,
                  altText: book.altText ?? 'Capa do livro ${book.title}',
                  fit: BoxFit.cover,
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
            ),
            //Like e adicionar ao ler mais tarde
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.favorite_border,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: Icon(
                        Icons.add,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}