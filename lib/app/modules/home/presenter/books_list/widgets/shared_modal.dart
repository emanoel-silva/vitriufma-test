import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:vitrine_ufma/app/core/components/text.dart';
import 'package:vitrine_ufma/app/core/constants/colors.dart';
import 'package:vitrine_ufma/app/core/constants/fonts_sizes.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';
import 'dart:html' as html;

class SharedModal extends StatefulWidget {
  final int listId;
  final ReadingListStore store;
  SharedModal({super.key, required this.listId, required this.store});

  @override
  State<SharedModal> createState() => _SharedModalState();
}

class _SharedModalState extends State<SharedModal> {
  late ReadingListStore store;
  bool allowAdd = false;

  @override
  void initState() {
    super.initState();
    store = widget.store;
    //TODO: setar lista como publica
    // store.setListPublic(widget.listId);
  }

  @override
  Widget build(BuildContext context) {
    final location = html.window.location;
    final String shareUrl = '${location.protocol}//${location.host}#/home/share/${widget.listId}';

    return Scaffold(
      backgroundColor: AppColors.black.withOpacity(0.5),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 600,
            maxWidth: 440,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text: widget.store.readingList[widget.listId]['name'] ==
                            'aee20c6a981fe6633c17340037ebb6472f1d8eb9'
                        ? 'Favoritos'
                        : widget.store.readingList[widget.listId]['name'],
                    fontSize: AppFontSize.fz10,
                    fontWeight: 'bold',
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),

              const SizedBox(height: 20),
              //qr code
              SizedBox(
                height: 200,
                child: PrettyQrView.data(
                  data: shareUrl,
                  decoration: const PrettyQrDecoration(
                    image: PrettyQrDecorationImage(
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const AppText(
                text:
                    'Copie o link abaixo ou escaneie para compartilhe esta lista de leitura',
                fontSize: AppFontSize.fz08,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              // Share link
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.lightGrey),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: shareUrl,
                        fontSize: AppFontSize.fz08,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: shareUrl));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Link copiado para a área de transferência')),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              //toogle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                      text: 'Adicionar lista aos destaques',
                      fontSize: AppFontSize.fz07),
                  Observer(
                    builder: (_) => Switch(
                      value: allowAdd,
                      onChanged: (value) {
                        //TODO: setar lista como destaque
                        // store.setListHighlight(widget.listId);
                        // store.setListPublic(widget.listId);
                        setState(() {
                          allowAdd = value;
                        });
                      },
                    ),
                  ),
                ],
              ),

              //Adicionar lista aos destaques
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     AppText(
              //         text: 'Adicionar lista aos destaques',
              //         fontSize: AppFontSize.fz07),
              //     Container(
              //       decoration: BoxDecoration(
              //         color: AppColors.blue,
              //         borderRadius: BorderRadius.circular(15),
              //       ),
              //       padding: EdgeInsets.all(AppConst.sidePadding),
              //       child: AppText(
              //         text: 'Adicionar',
              //         color: AppColors.white,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
