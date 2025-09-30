import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../errors/failures.dart';

abstract class IFileAccess {
  Future<Either<Failure, String?>> captureImageBase64(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, Uint8List?>> captureImageBytes(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, String?>> captureImagePath(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, String?>> pickImageBase64(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, Uint8List?>> pickImageBytes(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, FileData?>> pickImageBytesAndType(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, String?>> pickImagePath(
      {int? imageQuality, double? maxWidth, double? maxHeight});
  Future<Either<Failure, String?>> document();
}

class FileData {
  Uint8List data;
  String fileType;

  FileData({required this.data, required this.fileType});
}
