import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/colors.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';

import '../../../common/utils/utils.dart';
import '../../../common/widgets/custom_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const String routeName='/login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
final phoneController=TextEditingController();
Country? country;
@override
  void dispose() {
    // TODO: implement dispose
  phoneController.dispose();
  super.dispose();
  }

void pickCountry() {
  showCountryPicker(
      context: context,
      onSelect: (Country _country) {
        setState(() {
          country = _country;
        });
      });
}

void senderPhoneNumber(){
  String phoneNumber= phoneController.text.trim();
  if(Country !=null && phoneNumber.isNotEmpty){
    ref.read(authControllerProvider).signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
  }
  else{
    showSnackBar(context:context, content: 'Fill out of the filed',);
  }

}





  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:const Text('Enter your phone number'),
        backgroundColor: backgroundColor,
        elevation: 0,
              ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('WhatsApp will need to verify your phone number.'),
            const SizedBox(height: 10),
            TextButton(onPressed: pickCountry, child:const Text('Pick Country')),
            const SizedBox(height: 5),

            Row(
              children: [
              if(country != null)
               Text('+${country!.phoneCode}'),
                const SizedBox(width: 10.0,),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'phone number',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.6),
            SizedBox(
              width: 90,
              child: CustomButton(
                onPressed: senderPhoneNumber,
                text: 'NEXT',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
