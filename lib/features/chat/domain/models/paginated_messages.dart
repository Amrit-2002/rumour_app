import 'message_model.dart';

class PaginatedMessages {
  final List<MessageModel> messages;
  final dynamic lastDocument;

  const PaginatedMessages({
    required this.messages,
    this.lastDocument,
  });
}

