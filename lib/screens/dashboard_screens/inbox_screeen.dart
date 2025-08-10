import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:san_sprito/bloc/send_message/send_message_bloc.dart';
import 'package:san_sprito/bloc/send_message/send_message_event.dart';
import 'package:san_sprito/bloc/send_message/send_message_state.dart';
import 'package:san_sprito/common_widgets/common_button.dart';
import 'package:san_sprito/common_widgets/common_toast_widget.dart';
import 'package:san_sprito/common_widgets/shared_pref.dart';
import 'package:san_sprito/models/inbox_message_response.dart';

import '../../common_widgets/color_constant.dart';
import '../../common_widgets/common_app_bar.dart';

class MessageEntry {
  final String username;
  final String role;
  final String message;
  final String status;
  final String timestamp;

  MessageEntry(
    this.username,
    this.role,
    this.message,
    this.status,
    this.timestamp,
  );
}

class MessageDataSource extends DataTableSource {
  final List<MessageEntry> data;
  final Function(int index) onDelete;

  MessageDataSource({required this.data, required this.onDelete});

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final entry = data[index];
    return DataRow(
      cells: [
        DataCell(Text('${index + 1}')),
        DataCell(Text(entry.username)),
        DataCell(Text(entry.role)),
        DataCell(Text(entry.message)),
        DataCell(Text(entry.status)),
        DataCell(Text(entry.timestamp)),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => onDelete(index),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => 0;
}

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final List<String> _suggestions = ['Admin', 'User'];
  final List<String> _selectedItems = [];
  final List<String> _selectedIds = [];

  final TextEditingController _typeAheadController = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();
  final FocusNode messageFocus = FocusNode();
  String? userId;
  bool isLoad = false;
  int unReadCount = 0;

  List<MessageEntry>? messages;
  MessageDataSource? dataSource;
  InboxMessageData? inboxMessageData;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getUserIdAndLoadData();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          // This rebuild triggers showing suggestions even if input is empty
        });
      }
    });
  }

  void buildDataSource() {
    dataSource = MessageDataSource(
      data: messages ?? [],
      onDelete: (index) {
        setState(() {
          messages?.removeAt(index);
          buildDataSource(); // Rebuild data source after deletion
        });
        ToastService.showError("Deleted message at row ${index + 1}");
      },
    );
  }

  Future<void> getUserIdAndLoadData() async {
    final pref = await SharedPrefHelper.getInstance();
    userId = pref.getString('userId');
    debugPrint("gettingUserId: $userId");
    if (userId != null && userId!.isNotEmpty) {
      // ignore: use_build_context_synchronously
      context.read<SendMessageBloc>().add(
        AssignedInboxListEvent(loginId: userId ?? ""),
      );
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  void sendMessage() {
    if (userId != null && userId!.isNotEmpty) {
      context.read<SendMessageBloc>().add(
        SendMessageEvent(
          loginId: userId ?? "",
          adminIds: _selectedIds.first,
          messageContent: messageCtrl.text.trim(),
        ),
      );
    } else {
      debugPrint("UserId is null or empty — skipping API call");
    }
  }

  void msgSentSuccessfully() {
    ToastService.showSuccess("Message sent successfully");
    messageCtrl.clear();
    _selectedIds.clear();
    _selectedItems.clear();
    messageFocus.unfocus();
    isLoad = false;
  }

  Widget headerText({required String txt}) {
    return Text(
      txt,
      style: TextStyle(
        color: CommonColor.black,
        fontSize: 13,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendMessageBloc, SendMessageState>(
      listener: (context, state) {
        if (state is SendMessageLoading) {
          setState(() => isLoad = true);
        } else if (state is SendMessageSuccess) {
          msgSentSuccessfully();
        } else if (state is AssignedInboxListSuccess) {
          inboxMessageData = state.inboxMessageResponseList.data;
          unReadCount = inboxMessageData?.unreadCount ?? 0;
          debugPrint("inboxMessageData${inboxMessageData?.messages?.length}");
          messages = List.generate(
            inboxMessageData?.messages?.length ?? 0,
            (i) => MessageEntry(
              inboxMessageData?.messages?[i].senderName ?? "",
              inboxMessageData?.messages?[i].senderType ?? "",
              inboxMessageData?.messages?[i].messageContent ?? "",
              i % 3 == 0 ? "Unread" : "Read",
              inboxMessageData?.messages?[i].createdAt ?? "",
            ),
          );
          buildDataSource();
          isLoad = false;
        } else if (state is SendMessageFailure) {
          ToastService.showError(state.error);
          setState(() => isLoad = false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: const CommonAppBar(title: "Send Message", height: 230),
          backgroundColor: Colors.grey.shade300,
          body:
              isLoad
                  ? Center(
                    child: CircularProgressIndicator(
                      color: CommonColor.logoBGColor,
                    ),
                  )
                  : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Send message card
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Admin",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              headerText(txt: "Select Admin"),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children:
                                    _selectedItems.map((item) {
                                      return Chip(
                                        label: Text(item),
                                        deleteIcon: const Icon(Icons.close),
                                        onDeleted: () {
                                          setState(() {
                                            _selectedItems.remove(item);
                                            if (item == 'Admin') {
                                              _selectedIds.remove("1");
                                            }
                                            if (item == 'User') {
                                              _selectedIds.remove("2");
                                            }
                                          });
                                        },
                                      );
                                    }).toList(),
                              ),
                              const SizedBox(height: 8),
                              TypeAheadField<String>(
                                suggestionsCallback: (pattern) async {
                                  // Always return suggestions that are not already selected
                                  return _suggestions
                                      .where(
                                        (item) =>
                                            !_selectedItems.contains(item),
                                      )
                                      .toList();
                                },
                                itemBuilder:
                                    (context, suggestion) =>
                                        ListTile(title: Text(suggestion)),
                                onSelected: (suggestion) {
                                  setState(() {
                                    if (!_selectedItems.contains(suggestion)) {
                                      _selectedItems.add(suggestion);
                                      if (suggestion == 'Admin') {
                                        _selectedIds.add("1");
                                      } else if (suggestion == 'User') {
                                        _selectedIds.add("2");
                                      }
                                    }
                                    _typeAheadController.clear();
                                  });
                                },
                                controller: _typeAheadController,
                                focusNode: _focusNode,
                                builder: (context, controller, focusNode) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    decoration: const InputDecoration(
                                      hintText: 'Type to select...',
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                                emptyBuilder:
                                    (context) => const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("No items found"),
                                    ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                controller: messageCtrl,
                                maxLines: 5,
                                focusNode: messageFocus,
                                decoration: const InputDecoration(
                                  hintText: "Enter message",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              CommonButton(
                                onPressed: () {
                                  if (_selectedIds.isEmpty) {
                                    ToastService.showError(
                                      "Please select admin",
                                    );
                                  } else if (messageCtrl.text.isEmpty) {
                                    ToastService.showError(
                                      "Please enter message",
                                    );
                                  } else {
                                    sendMessage();
                                  }
                                },
                                isLoading: isLoad,
                                text: "Send",
                                height: 50,
                                width: double.infinity,
                                backgroundColor: CommonColor.green,
                                icon: Icons.send,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Text(
                          "Messages",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        PaginatedDataTable(
                          columns: const [
                            DataColumn(label: Text("#")),
                            DataColumn(label: Text("Username")),
                            DataColumn(label: Text("User Role")),
                            DataColumn(label: Text("Message")),
                            DataColumn(label: Text("Status")),
                            DataColumn(label: Text("Timestamp")),
                            DataColumn(label: Text("Action")),
                          ],
                          source:
                              dataSource ??
                              MessageDataSource(data: [], onDelete: (_) {}),
                          header: Text(
                            "You have $unReadCount unread message's",
                            style: TextStyle(fontSize: 20),
                          ),
                          rowsPerPage: 5,
                          availableRowsPerPage: const [5, 10, 15],
                          showFirstLastButtons: true,
                          columnSpacing: 12,
                        ),
                      ],
                    ),
                  ),
        );
      },
    );
  }
}
