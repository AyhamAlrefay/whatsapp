import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/chat_contact.dart';
import '../../../models/message.dart';

final chatControllerProvider=Provider((ref) {
  final chatRepository=ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);

} );



class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});


  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getChatContacts();
  }


  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }


  void sendTextMessage(
      {required BuildContext context,required String text,required String receiverUserId}) {
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            senderUser: value!));
  }


  void sendFileMessage(
      BuildContext context,
      File file,
      String receiverUserId,
      MessageEnum messageEnum,
     // bool isGroupChat,
      ) {
    //final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
        context: context,
        file: file,
        receiverUserId: receiverUserId,
        senderUserData: value!,
        messageEnum: messageEnum,
        ref: ref,
        //messageReply: messageReply,
       // isGroupChat: isGroupChat,
      ),
    );
    //ref.read(messageReplyProvider.state).update((state) => null);
  }


  void sendGIFMessage({
   required BuildContext context,
   required String gifUrl,
   required String receiverUserId,
    //  bool isGroupChat,
  }) {
    //final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
        context: context,
        gifUrl: newGifUrl,
        receiverUserId: receiverUserId,
        senderUser: value!,
        // messageReply: messageReply,
        // isGroupChat: isGroupChat,
      ),
    );
    // ref.read(messageReplyProvider.state).update((state) => null);
  }



}
