import 'package:flutter/material.dart';

class AdvancedSearch {
  Map<String, dynamic> filter = {"value": "all", "name": "Todos os Campos"};
  Map<String, dynamic> opType = {"value": "and", "name": "E"};

  //Filtros
  List filters = [
    {"value": "all", "name": "Todos os Campos"},
    {"value": "title", "name": "Título"},
    {"value": "author", "name": "Autor"},
    {"value": "theme", "name": "Assunto"},
    {"value": "tag", "name": "Tag"}
  ];
  List op = [
    {"value": "and", "name": "E"},
    {"value": "or", "name": "Ou"},
    {"value": "not", "name": "Não"}
  ];
  //Filtro de busca
  TextEditingController field = TextEditingController();

  //apply the filter
  void applyFilter(Map<String, dynamic> filter) {
    this.filter = filter;
    // update();
  }

  //apply op
  void applyOp(Map<String, dynamic> op) {
    this.opType = op;
    // update();
  }
}
