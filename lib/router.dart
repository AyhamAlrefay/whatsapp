
import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error_screen.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/features/chat/screen/mobile_chat_screen.dart';

import 'features/auth/screens/otp_screen.dart';

Route<dynamic> generateRouter(RouteSettings settings){
  switch(settings.name){
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context)=>const LoginScreen());

    case UserInformationScreen.routeName:
      return MaterialPageRoute(builder: (context)=>const UserInformationScreen());

    case MobileChatScreen.routeName:
      final arguments=settings.arguments as Map<String,dynamic>;
      final name=arguments['name'];
      final uid = arguments['uid'];
      return MaterialPageRoute(builder: (context)=> MobileChatScreen(name: name,uid:uid,));

    case OTPScreen.routeName:
      final verificationId=settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) =>OTPScreen(verificationId: verificationId)
      );
    default: return MaterialPageRoute(builder: (context)=>const Scaffold(
      body: ErrorScreen(error: 'This page doesn\'t exist'),
    ));

  }

}