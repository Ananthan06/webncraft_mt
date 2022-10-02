
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webncraft_mt/providers/employee_provider.dart';
import 'package:webncraft_mt/screens/employee_details_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late EmployeeDataProvider postMdl;

  @override
  void initState(){
    super.initState();
    final postMdl = context.read<EmployeeDataProvider>();
    postMdl.checkDbElseDownload(context);
  }


  @override
  Widget build(BuildContext context) {
    postMdl = context.watch<EmployeeDataProvider>();
    return Scaffold(
        appBar: AppBar(
          title:  const Text("Employees"),
          actions: [getRefresh()],
        ),
        body: postMdl.loading
            ? const Center(
          child: CircularProgressIndicator.adaptive(),
        )
            : !postMdl.networkNotAvailable
            ? getBody()
            : const Center(
          child: Text(
            "NETWORK UNAVAILABLE !",
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ));
  }

  /// displays body of the app
  Widget getBody() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black12,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          getSearchBar(),
          Expanded(
            child: postMdl.data != null && postMdl.data!.isNotEmpty
                ? RefreshIndicator(
              onRefresh: () => postMdl.checkDbElseDownload(context),
              child: ListView(
                  shrinkWrap: true,
                  children:
                  List.generate(postMdl.data!.length, (int index) {
                    return getListContentWidget(index);
                  })),
            )
                : getNoDataFound(),
          ),
        ],
      ),
    );
  }


  ///Text field widget to search items offline.
  Widget getSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: const InputDecoration(
          hintText: "Search",
          icon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        controller: postMdl.controller,
        onChanged: (value) {
          context.read<EmployeeDataProvider>().changeSearchString(value);
        },
      ),
    );
  }

  /// List view of card widget that shows each element with title,description and image.
  Widget getListContentWidget(int index) {
    return postMdl.data![index].name != "" &&
        postMdl.data![index].name != null
        ? InkWell(
            onTap: () async{
              await Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                      return EmployeeDetailsScreen(employeeDetails: postMdl.data![index]);
                    }));
            },
          child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          color: Colors.white,
          margin: EdgeInsets.only(top: index != 0 ? 11 : 0),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 24, left: 22, top: 22, bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  width: 40,
                  height: 40,
                  child:  postMdl.data![index].profileImage != null
                      ? Center(
                        child: CachedNetworkImage(
                        imageUrl: postMdl.data![index].profileImage ?? "",
                        placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) {
                          return const Center(child: Icon(Icons.error));
                        }),
                      )
                      :const Center(child: Icon(Icons.account_circle_outlined,
                  color: Colors.white,)),
                ),
                const SizedBox(width: 15,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postMdl.data![index].name ?? "",
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(postMdl.data![index].company?.name ?? "",
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 12)),
                    const SizedBox(
                      height: 3,
                    ),

                  ],
                ),
              ],
            ),
          )),
        )
        : const SizedBox();
  }

  ///Returns No data found text when list is empty.
  Widget getNoDataFound() {
    return const Center(
      child: Text(
        "NO DATA FOUND !",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }


  /// refresh button in app bar to reload the list by calling api
  Widget getRefresh() {
    return InkWell(
      onTap: () => postMdl.checkDbElseDownload(context),
      child: const Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    );
  }

}
