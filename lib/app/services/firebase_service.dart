import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:semesta/config/firebase_options.dart';
import 'package:semesta/public/helpers/generic_helper.dart';
import 'package:semesta/public/utils/type_def.dart';

class FirebaseService {
  AsWait init() async {
    final opt = DefaultFirebaseOptions.currentPlatform;
    final app = await Firebase.initializeApp(options: opt);

    FirebaseAuth.instanceFor(app: app);
    FirebaseAppCheck.instanceFor(app: app);

    await check.activate();
    await gg.initialize(serverClientId: token);
  }

  GoogleSignIn get gg => GoogleSignIn.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;
  // FacebookAuth get fb => FacebookAuth.instance;
  FirebaseStorage get cache => FirebaseStorage.instance;
  FirebaseFirestore get db => FirebaseFirestore.instance;
  FirebaseAppCheck get check => FirebaseAppCheck.instance;
}
