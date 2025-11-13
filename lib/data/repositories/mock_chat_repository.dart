// Mock chat repository for support chat
import '../models/support_message.dart';

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

  // Get FAQ items
  static List<FaqItem> getFaqItems() {
    return [
      const FaqItem(
        id: 'faq_1',
        question: 'How to lift P2P suspension',
        answer:
            'To lift your P2P suspension, go to Settings > Account > P2P Trading. Follow the verification steps to resolve any issues. If you need further assistance, contact our support team.',
      ),
      const FaqItem(
        id: 'faq_2',
        question: 'How to find the Restrictions Removal Center',
        answer:
            'Navigate to your account settings, then select Security > Restrictions. You\'ll find the Removal Center there where you can view and appeal any restrictions on your account.',
      ),
      const FaqItem(
        id: 'faq_3',
        question: 'How do I know the result of the lift suspension appeal',
        answer:
            'You will receive a notification via email and in-app notification once your appeal has been reviewed. Typically, appeals are processed within 24-48 hours. You can also check the status in Settings > Account > Appeals.',
      ),
      const FaqItem(
        id: 'faq_4',
        question: 'If your appeal is not accepted/rejected',
        answer:
            'If your appeal is pending for more than 48 hours, please contact our support team directly. You can reach us via this chat or email support@liberator.co.th with your appeal reference number.',
      ),
      const FaqItem(
        id: 'faq_5',
        question: 'If your appeal is accepted/completed',
        answer:
            'Once your appeal is accepted, the restrictions will be lifted within 1-2 hours. You will receive a confirmation notification and can resume normal trading activities immediately.',
      ),
      const FaqItem(
        id: 'faq_6',
        question:
            'If there is no P2P suspension on you, but you can\'t post ads',
        answer:
            'This might be due to other account restrictions or verification requirements. Please check: 1) Your KYC verification status, 2) Minimum account age requirements, 3) Trading volume requirements. Contact support if the issue persists.',
      ),
      const FaqItem(
        id: 'faq_7',
        question:
            'EEA (Europe) residents pay attention to the MiCA Stablecoin Rules Implementation',
        answer:
            'As per MiCA regulations, EEA residents are subject to specific stablecoin trading limits and verification requirements. Please ensure your account is fully verified and review the latest compliance guidelines in Settings > Compliance.',
      ),
    ];
  }

  // Get all messages (welcome + user message)
  static List<SupportMessage> getAllMessages() {
    return [getWelcomeMessage()];
  }
}
