class ApiRoutes {
//BaseUrl Allinsys
  static const String PROD = 'http://www.allinsys.com';
  static const String HOMOLOG = '';
  static const String BASE_URL = PROD;

  //Search City
  static const String SEARCH_CITY = "/api/app/hub/destination";

  //Login
  static const String LOGIN = "/api/app/operator/login";
  static const String REGISTER = "/api/app/operator/register";

  //Accommodation
  static const String AVAILABILITYHOTELS =
      "https://us-east1-prj-infra-europlus.cloudfunctions.net/events";

  //Currency
  static const String ORDER =
      'https://us-east1-prj-infra-europlus.cloudfunctions.net/order';

  //Currency
  static const String CURRENCY =
      'https://us-east1-prj-infra-europlus.cloudfunctions.net/order';

  static const String ALLINSYS_SERVER =
      "https://us-east1-prj-infra-allinsys.cloudfunctions.net";

  //Billing routes
  static const String BILLING_SERVICES = "https://us-east1-prj-infra-pass.cloudfunctions.net/order";
}
