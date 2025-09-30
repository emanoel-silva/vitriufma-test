import 'package:vitrine_ufma/app/core/errors/failures.dart';
import 'package:vitrine_ufma/app/core/service/client/i_client_http.dart';
import 'package:vitrine_ufma/app/modules/shared_module/infra/datasources/share_module_datasource.dart';

class ShareModuleDatasourceImpl implements IShareModuleDatasource {
  final IClientHttp http;

  ShareModuleDatasourceImpl({required this.http});
}
