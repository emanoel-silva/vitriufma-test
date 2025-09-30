abstract class IIPostMaterialDatasource {
  Future<Map> postInfoMaterial(Map<String, dynamic> data);
  Future<List> uploadBook(Map<String, dynamic> data);
  Future<String> uploadImage(List<int> imagePath,String fileName);
}
