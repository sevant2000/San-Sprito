import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:san_sprito/bloc/send_message/send_message_event.dart';
import 'package:san_sprito/bloc/send_message/send_message_state.dart';
import 'package:san_sprito/models/inbox_message_response.dart';
import 'package:san_sprito/models/send_message_response.dart';
import 'package:san_sprito/services/api_services.dart';
import 'package:http/http.dart' as http;

class SendMessageBloc extends Bloc<SendMessageEventClass, SendMessageState> {
  final ApiService apiService;

  SendMessageBloc({required this.apiService})
    : super(SendMessageInitial("Welcome")) {
    on<SendMessageEvent>((event, emit) async {
      emit(SendMessageLoading());

      try {
        final http.Response response = await apiService.sendMessage(
          loginId: event.loginId,
          adminIds: event.adminIds,
          messageContent: event.messageContent,
        );

        debugPrint("📨 API SendMessage: Status Code => ${response.statusCode}");
        debugPrint("📨 API SendMessage: Body => ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final model = SendMessageResoponse.fromJson(data);

          emit(SendMessageSuccess(sendMessageResponse: model));
        } else {
          emit(SendMessageFailure(error: "Failed to send message"));
        }
      } catch (e) {
        emit(SendMessageFailure(error: e.toString()));
      }
    });

    on<AssignedInboxListEvent>((event, emit) async {
      emit(SendMessageLoading());

      try {
        final http.Response response = await apiService.inboxMessageList(
          event.loginId,
        );

        debugPrint("📨 API SendMessage: Status Code => ${response.statusCode}");
        debugPrint("📨 API SendMessage: Body => ${response.body}");

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final model = InboxMessageResoponse.fromJson(data);

          emit(AssignedInboxListSuccess(inboxMessageResponseList: model));
        } else {
          emit(SendMessageFailure(error: "Failed to send message"));
        }
      } catch (e) {
        emit(SendMessageFailure(error: e.toString()));
      }
    });
  }
}
