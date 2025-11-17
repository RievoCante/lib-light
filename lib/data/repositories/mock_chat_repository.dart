// Mock chat repository for support chat
import '../models/support_message.dart';
import '../../localization/app_localizations.dart';

class MockChatRepository {
  // Get welcome message from support bot
  static SupportMessage getWelcomeMessage() {
    return SupportMessage(
      id: 'welcome_1',
      content:
          'Welcome! Let me know what issue you\'re facing — for example, "withdrawal failed" or "can\'t log in." You can also tap "+" for more help options.',
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: MessageType.text,
    );
  }

  // Get FAQ items from localization
  static List<FaqItem> getFaqItems(AppLocalizations l10n) {
    final questions = l10n.faqQuestions;
    return questions.asMap().entries.map((entry) {
      return FaqItem(id: 'faq_${entry.key + 1}', question: entry.value);
    }).toList();
  }

  // Get all messages (welcome + user message)
  static List<SupportMessage> getAllMessages() {
    return [getWelcomeMessage()];
  }
}
