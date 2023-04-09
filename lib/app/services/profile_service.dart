import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfileService {
  Future profileEdit(String id,{String? newName, int? newColor, LatLng? changeLocation}) async{
     var doc =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    
    var data = doc.data()!;

   if(newName != null){
    data["name"] = newName;
   }
   if(newColor != null){
    data["color"] = newColor;
   }
   if(changeLocation != null){
    data["location"] = changeLocation;
   }
   
    await FirebaseFirestore.instance.collection("users").doc(id).update(data);
  }
}