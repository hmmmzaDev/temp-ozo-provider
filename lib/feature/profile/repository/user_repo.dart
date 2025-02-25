import 'package:get/get.dart';
import 'package:demandium_provider/utils/core_export.dart';


class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  UserRepo(this.sharedPreferences, {required this.apiClient});

  Future<Response> getProviderInfo() async {
    return await apiClient.getData(AppConstants.providerProfileUri);
  }

  Future<Response?> getZonesDataList() async {
    return await apiClient.getData('${AppConstants.zoneUrl}?limit=200&offset=1');
  }

  Future<Response> updateProfile(String companyName,String companyPhone,String companyAddress,String lat, String lon, String companyEmail,
      String contactPersonName,String contactPersonPhone, String contactPersonEmail,String zoneId,XFile? profileImage) async {
      return await apiClient.postMultipartData(AppConstants.providerProfileUpdateUrl,
        {
          "company_name":companyName,
          "company_phone":contactPersonPhone,
          "company_address":companyAddress,
          "company_email":companyEmail,
          "contact_person_name":contactPersonName,
          "contact_person_phone":contactPersonPhone,
          "contact_person_email":contactPersonEmail,
          "zone_ids[]":zoneId,
          "latitude": lat,
          "longitude": lon,
          "_method": "put"
        },[],profileImage!=null?MultipartBody('logo', profileImage):null
    );
  }


  Future<Response> updateProfileWithPassword(String companyName,String companyPhone,String companyAddress, String companyEmail,
      String contactPersonName,String contactPersonPhone, String contactPersonEmail,String password,String confirmedPassword,String zoneId,String lat, String lon) async {
    return await apiClient.postMultipartData(AppConstants.providerProfileUpdateUrl,
        {
          "company_name":companyName,
          "company_phone":contactPersonPhone,
          "company_address":companyAddress,
          "company_email":companyEmail,
          "contact_person_name":contactPersonName,
          "contact_person_phone":contactPersonPhone,
          "contact_person_email":contactPersonEmail,
          "password": password,
          "confirm_password":confirmedPassword,
          "zone_ids[]":zoneId,
          "latitude": lat,
          "longitude": lon,
          "_method": "put"
        },null,null
    );
  }


  Future<Response> getBookingRequestData(String requestType, int offset) async {
    return await apiClient.postData(AppConstants.bookingListUrl,
        {"limit" : Get.find<SplashController>().configModel.content?.paginationLimit, "offset" : offset, "booking_status" : requestType});
  }
}