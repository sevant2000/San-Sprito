abstract class SendMessageEventClass {}

class SendMessageEvent extends SendMessageEventClass {
  final String loginId;
  // final List<String> adminIds;
  final String adminIds;
  final String messageContent;

  SendMessageEvent({
    required this.loginId,
    required this.adminIds,
    required this.messageContent,
  });
}

class AssignedInboxListEvent extends SendMessageEventClass {
  final String loginId;

  AssignedInboxListEvent({
    required this.loginId,
  });
}
