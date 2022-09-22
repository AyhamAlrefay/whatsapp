import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';

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
}
