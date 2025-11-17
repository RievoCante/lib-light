// Firestore chat repository for real-time support chat
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/support_message.dart';

class FirestoreChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get or create chat ID for a user (uses userId as chatId)
  Future<String> getOrCreateChatId(String userId) async {
    debugPrint('[FirestoreChatRepository] getOrCreateChatId: userId=$userId');
    try {
      final chatRef = _firestore.collection('chats').doc(userId);
      debugPrint('[FirestoreChatRepository] Chat ref path: ${chatRef.path}');

      // Check if chat document exists
      debugPrint(
        '[FirestoreChatRepository] Checking if chat document exists...',
      );
      final chatDoc = await chatRef.get().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('[FirestoreChatRepository] Timeout getting chat document');
          throw Exception('Timeout connecting to Firestore');
        },
      );

      debugPrint(
        '[FirestoreChatRepository] Chat document exists: ${chatDoc.exists}',
      );

      if (!chatDoc.exists) {
        debugPrint('[FirestoreChatRepository] Creating new chat document...');
        // Create new chat document
        await chatRef
            .set({
              'userId': userId,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            })
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                debugPrint(
                  '[FirestoreChatRepository] Timeout creating chat document',
                );
                throw Exception('Timeout creating chat in Firestore');
              },
            );

        debugPrint(
          '[FirestoreChatRepository] Chat document created, sending welcome message...',
        );
        // Send welcome message
        await sendWelcomeMessage(userId);
        debugPrint('[FirestoreChatRepository] Welcome message sent');
      } else {
        debugPrint('[FirestoreChatRepository] Chat document already exists');
      }

      debugPrint('[FirestoreChatRepository] Returning chatId: $userId');
      return userId;
    } catch (e, stackTrace) {
      debugPrint('[FirestoreChatRepository] Error in getOrCreateChatId: $e');
      debugPrint('[FirestoreChatRepository] Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Stream messages for a chat (real-time updates)
  Stream<List<SupportMessage>> getMessagesStream(String chatId) {
    debugPrint('[FirestoreChatRepository] getMessagesStream: chatId=$chatId');
    final messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');

    debugPrint(
      '[FirestoreChatRepository] Messages ref path: ${messagesRef.path}',
    );

    return messagesRef
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          debugPrint(
            '[FirestoreChatRepository] Message snapshot received: ${snapshot.docs.length} messages',
          );
          final messages = snapshot.docs
              .map((doc) {
                try {
                  return SupportMessage.fromFirestore(doc);
                } catch (e) {
                  debugPrint(
                    '[FirestoreChatRepository] Error parsing message ${doc.id}: $e',
                  );
                  return null;
                }
              })
              .whereType<SupportMessage>()
              .toList();
          debugPrint(
            '[FirestoreChatRepository] Parsed ${messages.length} messages',
          );
          return messages;
        })
        .handleError((error) {
          debugPrint(
            '[FirestoreChatRepository] Error in message stream: $error',
          );
          throw error;
        });
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String content,
    required String userId,
    required bool isFromUser,
    MessageType type = MessageType.text,
  }) async {
    debugPrint(
      '[FirestoreChatRepository] sendMessage: chatId=$chatId, userId=$userId, isFromUser=$isFromUser',
    );
    try {
      final messagesRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages');

      final message = SupportMessage(
        id: '', // Will be set by Firestore
        content: content,
        isFromUser: isFromUser,
        timestamp: DateTime.now(),
        type: type,
        userId: userId,
        chatId: chatId,
      );

      debugPrint('[FirestoreChatRepository] Adding message to Firestore...');
      await messagesRef
          .add(message.toFirestore())
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint('[FirestoreChatRepository] Timeout sending message');
              throw Exception('Timeout sending message to Firestore');
            },
          );

      debugPrint(
        '[FirestoreChatRepository] Message added, updating chat timestamp...',
      );
      // Update chat's last message timestamp
      await _firestore.collection('chats').doc(chatId).update({
        'updatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('[FirestoreChatRepository] Message sent successfully');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreChatRepository] Error sending message: $e');
      debugPrint('[FirestoreChatRepository] Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Send welcome message (admin/system message)
  Future<void> sendWelcomeMessage(String chatId) async {
    debugPrint('[FirestoreChatRepository] sendWelcomeMessage: chatId=$chatId');
    try {
      final welcomeContent =
          'Welcome! Let me know what issue you\'re facing — for example, "withdrawal failed" or "can\'t log in." You can also tap "+" for more help options.';

      // Check if welcome message already exists
      debugPrint(
        '[FirestoreChatRepository] Checking for existing welcome message...',
      );
      final existingWelcome = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .where('content', isEqualTo: welcomeContent)
          .limit(1)
          .get()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              debugPrint(
                '[FirestoreChatRepository] Timeout checking for welcome message',
              );
              throw Exception('Timeout checking welcome message');
            },
          );

      debugPrint(
        '[FirestoreChatRepository] Existing welcome messages found: ${existingWelcome.docs.length}',
      );

      if (existingWelcome.docs.isEmpty) {
        debugPrint(
          '[FirestoreChatRepository] No welcome message found, sending new one...',
        );
        await sendMessage(
          chatId: chatId,
          content: welcomeContent,
          userId: 'system',
          isFromUser: false,
        );
        debugPrint('[FirestoreChatRepository] Welcome message sent');
      } else {
        debugPrint(
          '[FirestoreChatRepository] Welcome message already exists, skipping',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[FirestoreChatRepository] Error in sendWelcomeMessage: $e');
      debugPrint('[FirestoreChatRepository] Stack trace: $stackTrace');
      // Don't rethrow - welcome message failure shouldn't block chat creation
    }
  }
}
