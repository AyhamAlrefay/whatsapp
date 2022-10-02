import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/features/auth/controller/auth_controller.dart';
import 'package:whatsapp/features/chat/repository/chat_repository.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../models/chat_contact.dart';
import '../../../models/group.dart';
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

  Stream<List<Group>> chatGroups() {
    return chatRepository.getChatGroups();
  }


  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }


  void sendTextMessage(
      {required BuildContext context,required String text,required String receiverUserId}) {
    final messageReply=ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendMessage(
            context: context,
            text: text,
            receiverUserId: receiverUserId,
            messageReply: messageReply,
            senderUser: value!));
  }


  void sendFileMessage(
      BuildContext context,
      File file,
      String receiverUserId,
      MessageEnum messageEnum,
     bool isGroupChat,
      ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
        context: context,
        file: file,
        receiverUserId: receiverUserId,
        senderUserData: value!,
        messageEnum: messageEnum,
        ref: ref,
        messageReply: messageReply,
       isGroupChat: isGroupChat,
      ),
    );
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context,
      String receiverUserId,
      String messageId,
      ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }



}
