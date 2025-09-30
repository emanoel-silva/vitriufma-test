import 'dart:typed_data';
import 'dart:ui';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import "package:flutter/material.dart";
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/const.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/register/material/register_material_store.dart';

class DragAndDrop extends StatelessWidget {
  final RegisterMaterialStore store;
  String? text;
  final bool cover;
  final bool isValid;
  DragAndDrop({super.key, this.text, required this.store, this.cover = true, this.isValid = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Observer(builder: (_) {
          if (cover ? store.file.isEmpty : store.fileSumary.isEmpty) {
            return InkWell(
              onTap: () async {
                PlatformFile? result = await store.uploadFile();

                if (result != null) {
                  if (cover) {
                    store.addFileCover(result);
                    return;
                  }
                  store.addFileSumary(result);
                } else {
                  // User canceled the picker
                }
              },
              child: DropTarget(
                  onDragDone: (details) async {
                    var path = details.files.first.path;
                    var name = details.files.first.name;
                    var size = await details.files.first.length();
                    PlatformFile file =
                        PlatformFile(path: path, name: name, size: size);
                    if (cover) {
                      store.addFileCover(file);
                      return;
                    }
                    store.addFileSumary(file);
                  },
                  onDragEntered: (details) => store.dragging = !store.dragging,
                  onDragExited: (details) => store.dragging = !store.dragging,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    color: isValid ? AppColors.normalRed : AppColors.cutGrey,
                    strokeWidth: 0.4,
                    dashPattern: [2],
                    radius: const Radius.circular(5),
                    child: Container(
                        alignment: Alignment.center,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              child: AppText(
                                text: "Clique aqui o arraste um arquivo",
                                fontSize: AppFontSize.fz04,
                                height: 1,
                                maxLines: 2,
                                color: AppColors.black,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                  )),
            );
          }

          if (cover && store.file.isNotEmpty) {
            //image preview
            return Container(
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.lightGrey,
                      width: 10,
                    ),
                  )),
              padding: EdgeInsets.symmetric(
                  horizontal: AppConst.sidePadding,
                  vertical: AppConst.sidePadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(
                          text: "Capa",
                          fontWeight: "medium",
                          fontSize: AppFontSize.fz05,
                          maxLines: 2,
                          height: 1,
                          color: AppColors.black,
                        ),
                        // const Spacer(),
                        InkWell(
                          onTap: () async {
                            store.removeFileCover();
                          },
                          child: const AppText(
                            text: "Remover",
                            fontWeight: "medium",
                            fontSize: AppFontSize.fz05,
                            height: 1,
                            color: AppColors.normalRed,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: Image.memory(
                        Uint8List.fromList(store.file),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container(
            decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.lightGrey,
                    width: 10,
                  ),
                )),
            padding: EdgeInsets.symmetric(
                horizontal: AppConst.sidePadding,
                vertical: AppConst.sidePadding),
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppText(
                      text: "Arquivo",
                      fontWeight: "regular",
                      fontSize: AppFontSize.fz05,
                      maxLines: 1,
                      height: 1,
                      color: AppColors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: AppText(
                        text: cover
                            ? "${store.fileName}"
                            : "${store.fileNameSumary}",
                        fontWeight: "medium",
                        fontSize: AppFontSize.fz04,
                        maxLines: 1,
                        height: 1,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    if (cover) {
                      store.removeFileCover();
                      return;
                    }
                    store.removeFileSumary();
                  },
                  child: const AppText(
                    text: "Remover",
                    fontWeight: "medium",
                    fontSize: AppFontSize.fz05,
                    height: 1,
                    color: AppColors.normalRed,
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
