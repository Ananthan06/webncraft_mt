
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webncraft_mt/models/employee_model.dart';
import 'package:webncraft_mt/screens/home_page.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  EmployeeData employeeDetails;
   EmployeeDetailsScreen({Key? key,  required this.employeeDetails}) : super(key: key);

  @override
  _EmployeeDetailsScreenState createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return onBackPress();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: (){
                onBackPress();
              },
            ),
            title:  const Text("Employee Details"),
          ),
          body: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.blue,
                    child:  Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueGrey,
                      ),
                      width: 40,
                      height: 40,
                      child: widget.employeeDetails.profileImage != null
                          ? Center(
                        child: CachedNetworkImage(
                            imageUrl:  widget.employeeDetails.profileImage ?? "",
                            placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) {
                              return const Center(child: Icon(Icons.error));
                            }),
                      )
                          :const Center(child: Icon(Icons.account_circle_outlined,
                        color: Colors.white,)),
                    ),
                  )),
              Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: ListView(
                      children: [
                        descriptionListTile("Name",  widget.employeeDetails.name ??""),
                        descriptionListTile("User Name",  widget.employeeDetails.username ??""),
                        descriptionListTile("Email",  widget.employeeDetails.email ??"NIL"),
                        descriptionListTile("Phone",  widget.employeeDetails.phone ??"NIL"),
                        descriptionListTile("Street",  widget.employeeDetails.address?.street ??"NIL"),
                        descriptionListTile("Suite",  widget.employeeDetails.address?.suite ??"NIL"),
                        descriptionListTile("City",  widget.employeeDetails.address?.city ??"NIL"),
                        descriptionListTile("Zip Code",  widget.employeeDetails.address?.zipcode ??"NIL"),
                        descriptionListTile("Website",  widget.employeeDetails.website ??"NIL"),
                        descriptionListTile("Company Name",  widget.employeeDetails.company?.name ??"NIL"),
                        descriptionListTile("Company Catch Phrase",  widget.employeeDetails.company?.catchPhrase ??"NIL"),
                        descriptionListTile("Company BS",  widget.employeeDetails.company?.bs ??"NIL"),

                      ],
                    ),
                  ))
            ],
          )
      ),
    );
  }

  Widget descriptionListTile(String title, String value){
    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: const TextStyle(color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 12),),

          Text( value,
            style: const TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15),),
        ],
      ),
    );
  }

  onBackPress() async{
   return await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return const MyHomePage();
        }));
  }
}
