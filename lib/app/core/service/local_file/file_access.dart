import 'dart:convert';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../errors/failures.dart';
import 'i_file_access.dart';

class FileAccess implements IFileAccess {
  final ImagePicker _picker;

  FileAccess(this._picker);

  @override
  Future<Either<Failure, String?>> captureImageBase64(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi capturada
      if (image == null) {
        return Right(null);
      }

      final imageBytes = await image.readAsBytes();
      String base64String = base64Encode(imageBytes);
      return Right(base64String);
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, Uint8List?>> captureImageBytes(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi capturada
      if (image == null) {
        return Right(null);
      }

      final imageBytes = await image.readAsBytes();
      return Right(imageBytes);
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, String?>> captureImagePath(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi capturada
      if (image == null) {
        return Right(null);
      }

      final imageBytes = await image.readAsBytes();
      String base64String = base64Encode(Uint8List.fromList(imageBytes));
      return Right(base64String);
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, String?>> pickImageBase64(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi escolhida
      if (image == null) {
        return Right(null);
      }

      final imageBytes = await image.readAsBytes();
      String base64String = base64Encode(Uint8List.fromList(imageBytes));
      return Right(base64String);
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, Uint8List?>> pickImageBytes(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi escolhida
      if (image == null) {
        return Right(null);
      }
      image.mimeType;
      final imageBytes = await image.readAsBytes();
      return Right(imageBytes);
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, FileData?>> pickImageBytesAndType(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi escolhida
      if (image == null) {
        return Right(null);
      }

      final imageBytes = await image.readAsBytes();
      return Right(
          FileData(data: imageBytes, fileType: image.mimeType ?? 'image/jpeg'));
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, String?>> pickImagePath(
      {int? imageQuality, double? maxWidth, double? maxHeight}) async {
    try {
      final image = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: imageQuality,
          maxWidth: maxWidth,
          maxHeight: maxHeight);

      // Verifica se a imagem foi escolhida
      if (image == null) {
        return Right(null);
      }

      return Right(image.path);
    } catch (e) {
      return Left(ServerException(
          message: 'Erro interno, por favor, tente mais tarde'));
    }
  }

  @override
  Future<Either<Failure, String?>> document() {
    // TODO: implement document
    throw UnimplementedError();
  }
}
