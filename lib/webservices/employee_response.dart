
import 'package:webncraft_mt/models/employee_model.dart';

class EmployeeApiResponse {
  List<EmployeeData>? rows;

  EmployeeApiResponse({this.rows});

  EmployeeApiResponse.fromJson(List<dynamic> json) {
    if (json.isNotEmpty) {
      rows = <EmployeeData>[];
      for (var v in json) {
        rows!.add( EmployeeData.fromJson(v));
      }
    }
  }

  EmployeeApiResponse.fromJsonDb(List<dynamic> json) {
    if (json.isNotEmpty) {
      rows = <EmployeeData>[];
      for (var v in json) {
        rows!.add( EmployeeData.fromJsonDb(v));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (rows != null) {
      data['rows'] = rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}