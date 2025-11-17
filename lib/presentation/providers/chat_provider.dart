// Chat provider for managing support chat state
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/support_message.dart';
import '../../data/repositories/firestore_chat_repository.dart';
import 'auth_provider.dart';

final firestoreChatRepositoryProvider = Provider<FirestoreChatRepository>((
  ref,
) {
  return FirestoreChatRepository();
});

final chatIdProvider = FutureProvider.autoDispose<String>((ref) async {
  debugPrint('[ChatProvider] chatIdProvider: Starting...');
  final authState = ref.watch(authProvider);

  debugPrint('[ChatProvider] authState.isLoading: ${authState.isLoading}');
  debugPrint('[ChatProvider] authState.hasError: ${authState.hasError}');
  debugPrint('[ChatProvider] authState.value: ${authState.value}');

  // Wait for auth state to be ready (not loading)
  if (authState.isLoading) {
    debugPrint('[ChatProvider] authState is still loading, throwing error');
    throw Exception('Waiting for authentication...');
  }

  final userId = authState.value?.userId;
  debugPrint('[ChatProvider] userId: $userId');

  if (userId == null) {
    debugPrint('[ChatProvider] userId is null, user not logged in');
    throw Exception('User not logged in. Please log in first.');
  }

  final repository = ref.watch(firestoreChatRepositoryProvider);
  try {
    debugPrint('[ChatProvider] Getting or creating chat ID for user: $userId');
    final chatId = await repository.getOrCreateChatId(userId);
    debugPrint('[ChatProvider] Chat ID obtained: $chatId');
    return chatId;
  } catch (e, stackTrace) {
    debugPrint('[ChatProvider] Error getting chat ID: $e');
    debugPrint('[ChatProvider] Stack trace: $stackTrace');
    throw Exception('Failed to initialize chat: $e');
  }
});

final chatMessagesProvider = StreamProvider.autoDispose<List<SupportMessage>>((
  ref,
) {
  debugPrint('[ChatProvider] chatMessagesProvider: Starting...');
  final chatIdAsync = ref.watch(chatIdProvider);

  return chatIdAsync.when(
    data: (chatId) {
      debugPrint(
        '[ChatProvider] Chat ID ready: $chatId, starting message stream',
      );
      final repository = ref.watch(firestoreChatRepositoryProvider);
      final stream = repository.getMessagesStream(chatId);
      debugPrint('[ChatProvider] Message stream created for chat: $chatId');
      return stream;
    },
    loading: () {
      debugPrint(
        '[ChatProvider] chatIdProvider is loading, returning empty stream temporarily',
      );
      // Return a stream that emits loading state
      // This will be handled by the UI's loading indicator
      return Stream.value(<SupportMessage>[]).asyncMap((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return <SupportMessage>[];
      });
    },
    error: (error, stack) {
      debugPrint('[ChatProvider] chatIdProvider has error: $error');
      debugPrint('[ChatProvider] Stack trace: $stack');
      // Return a stream that emits an empty list so UI can show error
      // The error will be handled in the UI
      return Stream.value(<SupportMessage>[]);
    },
  );
});
