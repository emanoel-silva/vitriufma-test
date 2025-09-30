import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:vitrine_ufma/app/core/service/local_storage/i_local_storage.dart';
import 'package:vitrine_ufma/app/core/utils/functions.dart';
import 'package:vitrine_ufma/app/modules/home/domain/entities/book.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/post_material_usecase.dart';
part 'register_material_store.g.dart';

class RegisterMaterialStore = _RegisterMaterialStoreBase
    with _$RegisterMaterialStore;

abstract class _RegisterMaterialStoreBase with Store {
  late ILocalStorage storage = Modular.get<ILocalStorage>();
  late IPostMaterialUsecase postMaterialUsecase =
      Modular.get<IPostMaterialUsecase>();

  //CONTROLLERS
  TextEditingController? callNumberController = TextEditingController();
  TextEditingController author1Controller = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController editionController = TextEditingController();
  TextEditingController publicationLocationController = TextEditingController();
  TextEditingController publicationYearController = TextEditingController();
  TextEditingController editingController = TextEditingController();
  TextEditingController pageNumbersController = TextEditingController();
  TextEditingController? isbnController = TextEditingController();
  TextEditingController? issnController = TextEditingController();
  TextEditingController? volumeController = TextEditingController();
  TextEditingController? rePrintingController = TextEditingController();
  TextEditingController materialTypeController = TextEditingController();
  TextEditingController languageController = TextEditingController();
  TextEditingController knolwedgeArea1Controller = TextEditingController();
  TextEditingController subKnolwedgeArea1Controller = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? avaliabilityController = TextEditingController();
  TextEditingController resumeController = TextEditingController();
  TextEditingController? subject1Controller = TextEditingController();
  String? coverImageURL;
  String? sumaryURL;

  @observable
  bool isThematic = false;

  @observable
  ObservableList<int> file = <int>[].asObservable();
  @observable
  ObservableList<int> fileSumary = <int>[].asObservable();
  @observable
  String? fileName;
  @observable
  String? fileNameSumary;
  @observable
  bool dragging = false;
  @observable
  bool loading = false;

  //Validadores
  @observable
  bool isCallNumberValid = true;
  @observable
  bool isTitleValid = true;
  @observable
  bool isAuthorValid = true;
  @observable
  bool isEditingValid = true;
  @observable
  bool isPublicationYearValid = true;
  @observable
  bool isResumeValid = true;
  @observable
  bool isKnolwedgeAreaValid = true;
  @observable
  bool isSubKnolwedgeAreaValid = true;
  @observable
  bool isSubjectValid = true;
  @observable
  bool isPageNumbersValid = true;
  @observable
  bool isIsbnValid = true;
  @observable
  bool isMaterialTypeValid = true;
  @observable
  bool isLanguageValid = true;
  @observable
  bool isCoverImageValid = true;
  @observable
  bool isSumaryValid = true;

  @action
  void setIsThematic(bool value) {
    isThematic = value;
  }

  void setForm(Book book) {
    author1Controller.text = book.author.join(',');
    titleController.text = book.title;
    editionController.text = book.edition;
    publicationYearController.text = book.publicationYear;
    editingController.text = book.publisher;
    pageNumbersController.text = book.numberOfPages.toString();
    isbnController!.text = book.isbn ?? "";
    issnController!.text = book.issn ?? "";
    volumeController!.text = book.volume.toString();
    rePrintingController!.text = book.reprintUpdate;
    materialTypeController.text = book.typer;
    languageController.text = book.language;
    knolwedgeArea1Controller.text = book.matters.join(',');
    subKnolwedgeArea1Controller.text = book.subMatters.join(',');
    emailController!.text = book.address;
    avaliabilityController!.text = book.availability;
    resumeController.text = book.abstract1;
    subject1Controller!.text = book.tags.join(',');
    coverImageURL = book.coverImage;
    sumaryURL = book.summary;
  }

  //CRIA JSON DO LIVRO
  Map<String, dynamic> toBook() {
    //Valida campos obrigatórios
    if (!validateFields()) {
      showSnackbarError('Campos obrigatórios não preenchidos');
      loading = false;
      throw Exception('Campos obrigatórios não preenchidos');
    }

    return {
      'title': titleController.text,
      'author': author1Controller.text.split(','),
      'publication_year': publicationYearController.text,
      'cover_image': coverImageURL,
      'file': sumaryURL,
      'abstract': resumeController.text,
      'matters': knolwedgeArea1Controller.text.split(','),
      'sub_matters': subKnolwedgeArea1Controller.text.split(','),
      'address': emailController?.text ?? "",
      'availability': avaliabilityController?.text ?? "",
      'summary': sumaryURL,
      'tags': subject1Controller?.text.split(','),
      'number_of_pages': pageNumbersController.text,
      'isbn': isbnController?.text ?? "",
      'issn': callNumberController?.text ?? "",
      'typer': materialTypeController.text,
      'language': languageController.text,
      'publisher': editingController.text,
      'volume': int.parse(volumeController?.text ?? "0"),
      'series': '0',
      'edition': editionController.text,
      'reprint_update': rePrintingController?.text ?? "0",
    };
  }

  @action
  Future<void> saveBook() async {
    loading = true;
    //Transform to Book
    Map<String, dynamic> book = toBook();
    //upload images
    try {
      await saveBookCover();
    } catch (e) {
      debugPrint(e.toString());
      showSnackbarError('Erro ao salvar imagem\n$e');
      loading = false;
      return;
    }

    //Cadastro do livro
    var result = await postMaterialUsecase.call(book);

    result.fold((error) {
      showSnackbarError('Erro ao cadastrar material\n$error');
    }, (response) {
      showSnackbarSuccess('Material cadastrado com sucesso');
      cleanFields();
    });

    loading = false;
  }

  Future<void> saveBookCover() async {
    var result = await Future.wait([
      postMaterialUsecase.uploadImage(List<int>.from(file), fileName!),
      postMaterialUsecase.uploadImage(
          List<int>.from(fileSumary), fileNameSumary!)
    ]);

    coverImageURL = result[0];
    sumaryURL = result[1];
  }

  @action
  bool validateFields() {
    bool isValid = true;

    // Basic required field validation
    isTitleValid = titleController.text.isNotEmpty;
    isAuthorValid = author1Controller.text.isNotEmpty;
    isEditingValid = editingController.text.isNotEmpty;
    isPublicationYearValid = _validateYear(publicationYearController.text);
    isResumeValid = resumeController.text.isNotEmpty;
    isKnolwedgeAreaValid = knolwedgeArea1Controller.text.isNotEmpty;
    isSubjectValid = subject1Controller?.text.isNotEmpty ?? false;
    isSubKnolwedgeAreaValid = subKnolwedgeArea1Controller.text.isNotEmpty;
    isPageNumbersValid = _validatePageNumbers(pageNumbersController.text);
    isIsbnValid = _validateISBN(isbnController?.text ?? "");
    isMaterialTypeValid = materialTypeController.text.isNotEmpty;
    isLanguageValid = languageController.text.isNotEmpty;
    isCoverImageValid = file.isNotEmpty;
    isSumaryValid = fileSumary.isNotEmpty;

    // Check if any validation failed
    isValid = isTitleValid &&
        isAuthorValid &&
        isEditingValid &&
        isPublicationYearValid &&
        isResumeValid &&
        isKnolwedgeAreaValid &&
        isSubjectValid &&
        isSubKnolwedgeAreaValid &&
        isPageNumbersValid &&
        isIsbnValid &&
        isMaterialTypeValid &&
        isLanguageValid &&
        isCoverImageValid &&
        isSumaryValid;

    return isValid;
  }

  // Validate year format and range
  bool _validateYear(String year) {
    if (year.isEmpty) return false;
    try {
      int yearNum = int.parse(year);
      return yearNum >= 1000 && yearNum <= DateTime.now().year;
    } catch (e) {
      return false;
    }
  }

  // Validate page numbers
  bool _validatePageNumbers(String pages) {
    if (pages.isEmpty) return false;
    try {
      int pagesNum = int.parse(pages);
      return pagesNum > 0;
    } catch (e) {
      return false;
    }
  }

  // Validate ISBN format
  bool _validateISBN(String isbn) {
    if (isbn.isEmpty) return false;
    // Remove hyphens and spaces
    isbn = isbn.replaceAll(RegExp(r'[-\s]'), '');
    // Check if ISBN is either 10 or 13 digits
    return RegExp(r'^(?:\d{10}|\d{13})$').hasMatch(isbn);
  }

  // Real-time field validation
  @action
  void validateField(String field, String value) {
    switch (field) {
      case 'title':
        isTitleValid = value.isNotEmpty;
        break;
      case 'author':
        isAuthorValid = value.isNotEmpty;
        break;
      case 'publication_year':
        isPublicationYearValid = _validateYear(value);
        break;
      case 'resume':
        isResumeValid = value.isNotEmpty;
        break;
      case 'knowledge_area':
        isKnolwedgeAreaValid = value.isNotEmpty;
        break;
      case 'subject':
        isSubjectValid = value.isNotEmpty;
        break;
      case 'sub_knowledge_area':
        isSubKnolwedgeAreaValid = value.isNotEmpty;
        break;
      case 'page_numbers':
        isPageNumbersValid = _validatePageNumbers(value);
        break;
      case 'isbn':
        isIsbnValid = _validateISBN(value);
        break;
      case 'material_type':
        isMaterialTypeValid = value.isNotEmpty;
        break;
      case 'language':
        isLanguageValid = value.isNotEmpty;
        break;
    }
  }

  @action
  Future<void> addFileCover(PlatformFile _file) async {
    var fileBytes = ObservableList<int>.of(_file.bytes!);

    file = kIsWeb
        ? fileBytes
        : ObservableList<int>.of(await XFile(_file.path!).readAsBytes());
    fileName = _file.name;
  }

  @action
  Future<void> addFileSumary(PlatformFile _file) async {
    var fileBytes = ObservableList<int>.of(_file.bytes!);

    fileSumary = kIsWeb
        ? fileBytes
        : ObservableList<int>.of(await XFile(_file.path!).readAsBytes());
    fileNameSumary = _file.name;
  }

  @action
  void removeFileCover() {
    file = <int>[].asObservable();
    fileName = null;
  }

  @action
  void removeFileSumary() {
    fileSumary = <int>[].asObservable();
    fileNameSumary = null;
  }

  void cleanFields() {
    callNumberController!.clear();
    author1Controller.clear();
    titleController.clear();
    editionController.clear();
    publicationLocationController.clear();
    editingController.clear();
    pageNumbersController.clear();
    isbnController?.clear();
    issnController?.clear();
    volumeController?.clear();
    rePrintingController?.clear();
    materialTypeController.clear();
    languageController.clear();
    knolwedgeArea1Controller.clear();
    subKnolwedgeArea1Controller.clear();
    emailController?.clear();
    avaliabilityController?.clear();
    resumeController.clear();
    subject1Controller?.clear();
    coverImageURL = null;
    sumaryURL = null;
    file = <int>[].asObservable();
    fileSumary = <int>[].asObservable();
    fileName = null;
    fileNameSumary = null;
  }

  // UPLOAD FILE AND IMAGE
  @action
  uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      onFileLoading: (status) => print(status),
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      print(result.files.first.name);

      return result.files.first;
    } else {
      return null;
    }
  }
}
