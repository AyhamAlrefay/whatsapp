import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/screens/mobile_screen_layout.dart';

import '../../../common/repositories/common_firebase_storage_repository.dart';
import '../../../models/user_model.dart';

final commonFirebaseStorageRepositoryProvider = Provider(
      (ref) => CommonFirebaseStorageRepository(
    firebaseStorage: FirebaseStorage.instance,
  ),
);


final authRepositoryProvider = Provider((ref) => AuthRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

 class AuthRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  AuthRepository({
    required this.firestore,
    required this.auth,
  });


  Future<UserModel?> getCurrentUserData() async {
    var userData =
    await firestore.collection('users').doc(auth.currentUser?.uid).get();

    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }


  void signInWithPhone(
      {required BuildContext context, required String phoneNumber}) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.pushNamed(context, OTPScreen.routeName,
                arguments: verificationId);
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOtp({
   required BuildContext context,
    required String verificationId,
    required String userOtp
 })async{
try{
PhoneAuthCredential credential = PhoneAuthProvider.credential(
  verificationId:verificationId, smsCode: userOtp,
);
await auth.signInWithCredential(credential);
Navigator.pushNamedAndRemoveUntil(context, UserInformationScreen.routeName, (route) => false);
}on FirebaseException catch (e) {
  showSnackBar(context: context, content: e.message!);
}
  }


  void saveUserDataToFirebase({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://png.pngitem.com/pimgs/s/649-6490124_katie-notopoulos-katienotopoulos-i-write-about-tech-round.png';

      if (profilePic != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
          'profilePic/$uid',
          profilePic,
        );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const MobileScreenLayout(),
        ),
            (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

}
