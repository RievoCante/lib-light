// Support chat page with Firestore real-time chat
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/repositories/mock_chat_repository.dart';
import '../../../localization/app_localizations.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/chat_provider.dart';
import '../../widgets/chat/message_bubble.dart';
import '../../widgets/chat/faq_item_widget.dart';

class SupportChatPage extends ConsumerStatefulWidget {
  const SupportChatPage({super.key});

  @override
  ConsumerState<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends ConsumerState<SupportChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFaq = false;
  int _previousMessageCount = 0;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFaqView() {
    setState(() {
      _showFaq = !_showFaq;
    });
    if (_showFaq) {
      _scrollToBottom();
    }
  }

  Future<void> _sendFaqQuestion(String question) async {
    final authState = ref.read(authProvider);
    final userId = authState.value?.userId;
    final chatIdAsync = ref.read(chatIdProvider);

    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to send messages')),
        );
      }
      return;
    }

    chatIdAsync.whenData((chatId) async {
      final repository = ref.read(firestoreChatRepositoryProvider);
      try {
        await repository.sendMessage(
          chatId: chatId,
          content: question,
          userId: userId,
          isFromUser: true,
        );
        // Hide FAQ view after sending
        setState(() {
          _showFaq = false;
        });
        _scrollToBottom();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
        }
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final authState = ref.read(authProvider);
    final userId = authState.value?.userId;
    final chatIdAsync = ref.read(chatIdProvider);

    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to send messages')),
        );
      }
      return;
    }

    chatIdAsync.whenData((chatId) async {
      final repository = ref.read(firestoreChatRepositoryProvider);
      try {
        await repository.sendMessage(
          chatId: chatId,
          content: text,
          userId: userId,
          isFromUser: true,
        );
        _messageController.clear();
        // Scroll to bottom after sending
        _scrollToBottom();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to send message: $e')));
        }
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final messagesAsync = ref.watch(chatMessagesProvider);
    final chatIdAsync = ref.watch(chatIdProvider);

    debugPrint(
      '[SupportChatPage] messagesAsync.isLoading: ${messagesAsync.isLoading}',
    );
    debugPrint(
      '[SupportChatPage] messagesAsync.hasError: ${messagesAsync.hasError}',
    );
    debugPrint(
      '[SupportChatPage] messagesAsync.hasValue: ${messagesAsync.hasValue}',
    );
    debugPrint(
      '[SupportChatPage] chatIdAsync.isLoading: ${chatIdAsync.isLoading}',
    );
    debugPrint(
      '[SupportChatPage] chatIdAsync.hasError: ${chatIdAsync.hasError}',
    );
    debugPrint('[SupportChatPage] chatIdAsync.error: ${chatIdAsync.error}');

    // Auto-scroll when new messages arrive
    ref.listen(chatMessagesProvider, (previous, next) {
      debugPrint('[SupportChatPage] Message stream updated');
      next.whenData((messages) {
        debugPrint('[SupportChatPage] Received ${messages.length} messages');
        final currentCount = messages.length;
        if (currentCount > _previousMessageCount) {
          _previousMessageCount = currentCount;
          _scrollToBottom();
        } else if (_previousMessageCount == 0 && currentCount > 0) {
          // Initialize count on first load
          _previousMessageCount = currentCount;
          _scrollToBottom();
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFFF0B90B)
                    : const Color(0xFFFCD535),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Icon(Icons.support_agent, color: Colors.black, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(l10n.supportChat, style: AppTextStyles.h3)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.language), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: chatIdAsync.when(
              data: (_) {
                // Chat ID is ready, show messages
                return messagesAsync.when(
                  data: (messages) {
                    debugPrint(
                      '[SupportChatPage] Rendering ${messages.length} messages',
                    );
                    return ListView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        // View Chat History button
                        Center(
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.access_time,
                              size: 16,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                            label: Text(
                              l10n.viewChatHistory,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Messages from Firestore
                        ...messages.map(
                          (message) => MessageBubble(message: message),
                        ),

                        // FAQ Items (only show when _showFaq is true)
                        if (_showFaq) ...[
                          const SizedBox(height: 16),
                          ...MockChatRepository.getFaqItems(l10n).map(
                            (faqItem) => FaqItemWidget(
                              faqItem: faqItem,
                              onTap: () => _sendFaqQuestion(faqItem.question),
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),
                      ],
                    );
                  },
                  loading: () {
                    debugPrint('[SupportChatPage] Messages are loading...');
                    return const Center(child: CircularProgressIndicator());
                  },
                  error: (error, stack) {
                    debugPrint(
                      '[SupportChatPage] Error loading messages: $error',
                    );
                    debugPrint('[SupportChatPage] Stack trace: $stack');
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading messages',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                debugPrint('[SupportChatPage] Retrying...');
                                // ignore: unused_result
                                ref.refresh(chatMessagesProvider);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () {
                debugPrint('[SupportChatPage] Chat ID is loading...');
                return const Center(child: CircularProgressIndicator());
              },
              error: (error, stack) {
                debugPrint('[SupportChatPage] Error getting chat ID: $error');
                debugPrint('[SupportChatPage] Stack trace: $stack');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error initializing chat',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            debugPrint('[SupportChatPage] Retrying chat ID...');
                            // ignore: unused_result
                            ref.refresh(chatIdProvider);
                            // ignore: unused_result
                            ref.refresh(chatMessagesProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom buttons and input
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Recent Orders and FAQ buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {}, // No function yet
                          icon: const Icon(Icons.receipt_long, size: 16),
                          label: Text(
                            l10n.recentOrders,
                            style: AppTextStyles.bodySmall,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _toggleFaqView,
                          icon: const Icon(Icons.help_outline, size: 16),
                          label: Text('FAQ', style: AppTextStyles.bodySmall),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _showFaq
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).textTheme.bodyMedium?.color,
                            side: BorderSide(
                              color: _showFaq
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).dividerColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Text input field
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: l10n.searchOrAsk,
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white54
                                  : Colors.black45,
                            ),
                            filled: true,
                            fillColor: isDarkMode
                                ? const Color(0xFF2B3139)
                                : Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _sendMessage,
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        padding: const EdgeInsets.all(12),
                        style: IconButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? const Color(0xFF2B3139)
                              : Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
