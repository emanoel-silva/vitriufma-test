import 'package:vitrine_ufma/app/core/core_module.dart';
import 'package:vitrine_ufma/app/core/store/layout/layout_store.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/repositories/login_repository.dart';
import 'package:vitrine_ufma/app/modules/auth/domain/usecases/logout_usecase.dart';
import 'package:vitrine_ufma/app/modules/auth/external/login_datasource.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/datasources/login_datasource.dart';
import 'package:vitrine_ufma/app/modules/auth/infra/repositories/login_repository.dart';
import 'package:vitrine_ufma/app/modules/home/domain/repositories/info_material_repository.dart';
import 'package:vitrine_ufma/app/modules/home/domain/repositories/post_material_repository.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/info_material_usecase.dart';
import 'package:vitrine_ufma/app/modules/home/domain/usecases/post_material_usecase.dart';
import 'package:vitrine_ufma/app/modules/home/external/info_material_datasource.dart';
import 'package:vitrine_ufma/app/modules/home/external/post_material_datasource.dart';
import 'package:vitrine_ufma/app/modules/home/infra/datasource/info_material_datasource.dart';
import 'package:vitrine_ufma/app/modules/home/infra/datasource/post_material_datasource.dart';
import 'package:vitrine_ufma/app/modules/home/infra/repositories/info_material_repository.dart';
import 'package:vitrine_ufma/app/modules/home/infra/repositories/post_material_repository.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/about_us/about_us.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/acessibilities/acessibilities_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/favorites_list/favorites_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/reading_list/reading_list_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/books_list/shared_list/shared_list_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/detail_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/detail/detail_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/help/help_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/home/home_books_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/home/home_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/manage/manage_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/manage/manage_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/register/material/register_material_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/register/material/register_material_store.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/advanced_search/advanced_search.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/result/result_page.dart';
import 'package:vitrine_ufma/app/modules/home/presenter/search/search_store.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    apisUsecases(i);

    i.addSingleton(() => LayoutStore());
    i.addSingleton<HomeStore>(HomeStore.new);
    i.addSingleton<DetailStore>(DetailStore.new);
    i.addSingleton<SearchStore>(SearchStore.new);
    i.add<ReadingListStore>(ReadingListStore.new);
    i.add<ManageStore>(ManageStore.new);
    i.add<RegisterMaterialStore>(RegisterMaterialStore.new);
  }

  void apisUsecases(i) {
    i.add<IInfoMaterialRepository>(InfoMaterialRepositoryImpl.new);
    i.add<IIInfoMaterialDatasource>(InfoMaterialDatasource.new);
    i.add<IInfoMaterialUsecase>(InfoMaterialUseCaseImpl.new);


    i.add<IIPostMaterialDatasource>(PostMaterialDatasource.new);
    i.add<IPostMaterialRepository>(PostMaterialRepositoryImpl.new);
    i.add<IPostMaterialUsecase>(PostMaterialUseCaseImpl.new);

    i.add<ILoginRepository>(LoginRepositoryImpl.new);
    i.add<ILoginDatasource>(LoginDatasource.new);
    i.add<ILogoutUsecase>(LogoutGoogleImpl.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child(
      '/',
      child: (ctx) => HomePage(),
      transition: TransitionType.downToUp,
      children: [
        ChildRoute('/books',
            child: (ctx) => HomeBooksPage(
                  store: Modular.get<HomeStore>(),
                )),
        ChildRoute('/books/:id',
            child: (ctx) => DetailPage(
                )),
        ChildRoute('/result/:search',
            child: (ctx) => ResultSearchPage(
                )),

        ChildRoute('/search',
            child: (ctx) => AdvancedSearchPage(
                )),
        ChildRoute('/list/reading', 
            child: (ctx) => ReadingListPage(

                )),
        ChildRoute('/list/favorites',
            child: (ctx) => FavoritesListPage(
                )),
        ChildRoute('/share/:id',
            child: (ctx) => SharedListPage(
                )),
        ChildRoute('/manage',
            child: (ctx) => ManagePage(
                )),
        ChildRoute('/register',
            child: (ctx) => RegisterMaterialPage(
                )),
        

        ChildRoute('/help',
            child: (ctx) => HelpPage(
                )),
        ChildRoute('/acessibilities',
            child: (ctx) => AcessibilitiesPage(
                )),
        ChildRoute('/about',
            child: (ctx) => AboutUsPage(
                )),
      ],
    );

    // r.redirect('/', to: '/dashboard');
  }
}
