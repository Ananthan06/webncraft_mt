
import 'package:flutter/material.dart';
import 'package:webncraft_mt/database/database_helper.dart';
import 'package:webncraft_mt/models/employee_model.dart';
import 'package:webncraft_mt/utils/network_utils.dart';
import 'package:webncraft_mt/webservices/employee_response.dart';
import 'package:webncraft_mt/webservices/webservices.dart';

class EmployeeDataProvider with ChangeNotifier {
  EmployeeApiResponse post = EmployeeApiResponse();
  List<EmployeeData>? dataList;
  bool loading = true;
  late bool networkNotAvailable;
  final controller = TextEditingController();
  String _searchString = "";
  DatabaseHelper helper = DatabaseHelper();

  Future<void> checkDbElseDownload(context) async{
    int? _count = await helper.getCountInTable("employee");
    if(_count !=null && _count>0){
      var listFromDb = [];
      listFromDb= await helper.getFromDb();
      post = EmployeeApiResponse();
      post = EmployeeApiResponse.fromJsonDb(listFromDb);
      loading = false;
      networkNotAvailable = false;
      notifyListeners();
    }else{
       await getPostData(context);
    }
  }
  /// This future function awaits for api response and updates the UI.
  Future<void> getPostData(context) async {
    loading = true;
    notifyListeners();
    int status = await NetworkUtils().isNetworkAvailable();
    if (status != 0 && status == 1) {
      networkNotAvailable = false;
      try {
        post = await WebServices().getResponsePostData(context);
        for(var v in post.rows!){
          helper.insertReferral(v);
        }
        loading = false;
        _searchString = "";
        controller.clear();
      } catch (e) {
        loading = false;
      }
    } else {
      networkNotAvailable = true;
      loading = false;
    }
    notifyListeners();
  }

  /// Filter searched item with title of the list and returns the value.
  List<EmployeeData>? get data => _searchString.isEmpty
      ? post.rows
      : post.rows
      ?.where((element) =>
  element.name != null &&
      ( element.name!.toLowerCase().contains(_searchString.toLowerCase()) ||
      element.email!.toLowerCase().contains(_searchString.toLowerCase())) )
      .toList();

  /// Function to implement simple search functionality.
  void changeSearchString(String searchString) {
    _searchString = searchString;
    notifyListeners();
  }

}
