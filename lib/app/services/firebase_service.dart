import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semesta/config/firebase_options.dart';

class FirebaseService {
  Future<void> init() async {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth.instanceFor(app: app);
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate();
    await gg.initialize(
      serverClientId:
          '186960173803-q8c82j37onennb9inhf09tffh8optgq3.apps.googleusercontent.com',
    );
  }

  FirebaseAuth get auth => FirebaseAuth.instance;
  GoogleSignIn get gg => GoogleSignIn.instance;
  // FacebookAuth get fb => FacebookAuth.instance;
  FirebaseFirestore get db => FirebaseFirestore.instance;
  FirebaseStorage get ud => FirebaseStorage.instance;
}
