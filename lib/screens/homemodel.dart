import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map<String,dynamic>> get(String str,String entity) async{
  if(str.isEmpty) return {};
  try{
    final rep = await http.get(Uri.parse("https://itunes.apple.com/search?term=$str&entity=$entity&limit=6"));
    if(rep.statusCode == 200){
      return jsonDecode(rep.body);
    }else{
      return {};
    }
  }catch(e){
    print("Error: $e");
    return {};
  }
}

checkConnectivity(ValueChanged<bool> onChange){
  Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
    if(result.contains(ConnectivityResult.none)){
      onChange(true);
    }else{
      onChange(false);
    }
  });
}

notFound(BuildContext context){
  return Container(
    height: MediaQuery.of(context).size.height*0.9,
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10)
        )
    ),
    alignment: Alignment.center,
    child: const Text("Internet not found",style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: 20
    ),),
  );
}

tag(BuildContext context, String name){
  return Container(
    height: 45,
    width: MediaQuery.of(context).size.width,
    color: Colors.white,
    alignment: Alignment.centerLeft*0.95,
    child: Text(name,
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600
    ),),
  );
}

suggestionWidget(Map<String,dynamic> data){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: GridView.builder(
        shrinkWrap: true,
        itemCount: data["results"].length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            childAspectRatio: 0.75
        ), itemBuilder: (context,index){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(data["results"][index]["artworkUrl100"],
              fit: BoxFit.none,
            ),
            const SizedBox(height: 10,),
            SizedBox(
                width: MediaQuery.of(context).size.width*0.2,
                child: Text(data["results"][index]["trackName"],textAlign: TextAlign.center,maxLines: 2,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),)),
          ],
        ),
      );
    }),
  );
}