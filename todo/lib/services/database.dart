import 'package:cloud_firestore/cloud_firestore.dart';

class UserName{
  final String uid;
  UserName(this.uid);
  // collection ref
  final CollectionReference namesCollection = FirebaseFirestore.instance.collection("userNames");
  

  // for setting and then later updating the username
  Future updateUserName(String userName) async{
    return await namesCollection.doc(uid).set({
      'userName' : userName,
    });
  }
}