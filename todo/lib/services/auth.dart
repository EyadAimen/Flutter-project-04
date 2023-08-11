import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/services/database.dart';

// this class will have all the functions that will interact with firebes authentication services
class AuthService{
  // creating a firebaseAuth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change stream
  Stream<User?> get user{
    return _auth.authStateChanges();
  }
  // sign in witth email and password
  Future signIn(String email, String password) async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch(e){
      return null;
    }
  } 

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String userName) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // here will store the username in the firestore
      UserName(user!.uid).updateUserName(userName);
      return user;
    } catch(e){
      return null;
    }
  }

  // signOut function
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      return null;
    }
  }
}