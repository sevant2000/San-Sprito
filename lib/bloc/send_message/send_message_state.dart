import 'package:san_sprito/models/inbox_message_response.dart';
import 'package:san_sprito/models/send_message_response.dart';

abstract class SendMessageState {}

class SendMessageInitial extends SendMessageState {
  final String message;

  SendMessageInitial(this.message);
}

class SendMessageLoading extends SendMessageState {}

class SendMessageSuccess extends SendMessageState {
  final SendMessageResoponse sendMessageResponse;
  SendMessageSuccess({required this.sendMessageResponse});
}

class SendMessageFailure extends SendMessageState {
  final String error;

  SendMessageFailure({required this.error});
}

class AssignedInboxListSuccess extends SendMessageState {
  final InboxMessageResoponse inboxMessageResponseList;
  AssignedInboxListSuccess({required this.inboxMessageResponseList});
}
