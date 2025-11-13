// Support chat page with FAQ and mock messages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/support_message.dart';
import '../../../data/repositories/mock_chat_repository.dart';
import '../../../localization/app_localizations.dart';
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
  List<FaqItem> _faqItems = [];
  List<SupportMessage> _messages = [];
  bool _showFaq = false;

  @override
  void initState() {
    super.initState();
    _faqItems = MockChatRepository.getFaqItems();
    _messages = [MockChatRepository.getWelcomeMessage()];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleFaqItem(int index) {
    setState(() {
      _faqItems[index] = _faqItems[index].copyWith(
        isExpanded: !_faqItems[index].isExpanded,
      );
    });
  }

  void _toggleFaqView() {
    setState(() {
      _showFaq = !_showFaq;
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        SupportMessage(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          content: text,
          isFromUser: true,
          timestamp: DateTime.now(),
          type: MessageType.text,
        ),
      );
      _messageController.clear();
    });

    // Auto-scroll to bottom after sending
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
            child: ListView(
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
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    label: Text(
                      l10n.viewChatHistory,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Messages
                ..._messages.map((message) => MessageBubble(message: message)),

                // FAQ Items (only show when _showFaq is true)
                if (_showFaq) ...[
                  const SizedBox(height: 16),
                  ..._faqItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final faqItem = entry.value;
                    return FaqItemWidget(
                      faqItem: faqItem,
                      onTap: () => _toggleFaqItem(index),
                    );
                  }),
                ],

                const SizedBox(height: 16),
              ],
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
