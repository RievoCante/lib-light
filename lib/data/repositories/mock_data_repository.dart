// Mock data repository for realistic test data
import '../models/user.dart';
import '../models/market_data.dart';
import '../models/stock.dart';
import '../models/stock_list_item.dart';
import '../models/order_book.dart';
import '../models/portfolio.dart';
import '../models/calendar_event.dart';
import '../models/article.dart';
import '../models/notification.dart';

class MockDataRepository {
  MockDataRepository._();

  // Mock User
  static User getMockUser() {
    return const User(
      userId: '70426672',
      accountNumber: '70426672(C)',
      isLoggedIn: true,
      rememberMe: true,
    );
  }

  // Mock Market Data
  static MarketData getMockMarketData() {
    return const MarketData(
      index: 'SET',
      value: 1318.40,
      change: -5.12,
      percentChange: -0.39,
      marketCap: '29,204.97 M',
      status: 'open',
    );
  }

  // Mock Stock Data - Real Thai stocks
  static Stock getMockStock(String symbol) {
    final mockStocks = _getAllMockStocks();
    return mockStocks[symbol] ?? mockStocks['PTT']!;
  }

  // Get all Thai stocks list
  static List<StockListItem> getThaiStocksList() {
    return [
      const StockListItem(
        symbol: 'PTT',
        fullName: 'PTT Public Company Limited',
        shortName: 'PTT PCL',
        currentPrice: 38.50,
        change: -0.75,
        percentChange: -1.91,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'KBANK',
        fullName: 'Kasikornbank Public Company Limited',
        shortName: 'KASIKORNBANK',
        currentPrice: 142.50,
        change: 2.50,
        percentChange: 1.79,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'AOT',
        fullName: 'Airports of Thailand Public Company Limited',
        shortName: 'AOT',
        currentPrice: 65.25,
        change: -1.25,
        percentChange: -1.88,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'CPALL',
        fullName: '7-Eleven (CP ALL) Public Company Limited',
        shortName: 'CP ALL',
        currentPrice: 64.75,
        change: 0.75,
        percentChange: 1.17,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'ADVANC',
        fullName: 'Advanced Info Service Public Company Limited',
        shortName: 'ADVANCED INFO',
        currentPrice: 225.00,
        change: -3.00,
        percentChange: -1.32,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'SCB',
        fullName: 'Siam Commercial Bank Public Company Limited',
        shortName: 'SCB',
        currentPrice: 108.50,
        change: 1.50,
        percentChange: 1.40,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'BBL',
        fullName: 'Bangkok Bank Public Company Limited',
        shortName: 'BANGKOK BANK',
        currentPrice: 145.00,
        change: -2.00,
        percentChange: -1.36,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'DELTA',
        fullName: 'Delta Electronics (Thailand) Public Company Limited',
        shortName: 'DELTA',
        currentPrice: 52.25,
        change: 1.25,
        percentChange: 2.45,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'TRUE',
        fullName: 'True Corporation Public Company Limited',
        shortName: 'TRUE',
        currentPrice: 5.85,
        change: -0.10,
        percentChange: -1.68,
        currency: 'THB',
      ),
      const StockListItem(
        symbol: 'INTUCH',
        fullName: 'Intouch Holdings Public Company Limited',
        shortName: 'INTOUCH',
        currentPrice: 68.50,
        change: 0.50,
        percentChange: 0.74,
        currency: 'THB',
      ),
    ];
  }

  // Get detailed stock data
  static Map<String, Stock> _getAllMockStocks() {
    return {
      'PTT': const Stock(
        symbol: 'PTT',
        currentPrice: 38.50,
        currency: 'THB',
        change: -0.75,
        percentChange: -1.91,
        high: 39.50,
        low: 38.25,
        open: 39.00,
        previousClose: 39.25,
        ceiling: 43.00,
        floor: 35.00,
      ),
      'KBANK': const Stock(
        symbol: 'KBANK',
        currentPrice: 142.50,
        currency: 'THB',
        change: 2.50,
        percentChange: 1.79,
        high: 143.00,
        low: 140.00,
        open: 140.50,
        previousClose: 140.00,
        ceiling: 154.00,
        floor: 126.00,
      ),
      'AOT': const Stock(
        symbol: 'AOT',
        currentPrice: 65.25,
        currency: 'THB',
        change: -1.25,
        percentChange: -1.88,
        high: 66.75,
        low: 65.00,
        open: 66.50,
        previousClose: 66.50,
        ceiling: 73.00,
        floor: 60.00,
      ),
      'CPALL': const Stock(
        symbol: 'CPALL',
        currentPrice: 64.75,
        currency: 'THB',
        change: 0.75,
        percentChange: 1.17,
        high: 65.00,
        low: 64.00,
        open: 64.00,
        previousClose: 64.00,
        ceiling: 70.00,
        floor: 58.00,
      ),
      'ADVANC': const Stock(
        symbol: 'ADVANC',
        currentPrice: 225.00,
        currency: 'THB',
        change: -3.00,
        percentChange: -1.32,
        high: 228.00,
        low: 224.00,
        open: 227.00,
        previousClose: 228.00,
        ceiling: 251.00,
        floor: 205.00,
      ),
      'SCB': const Stock(
        symbol: 'SCB',
        currentPrice: 108.50,
        currency: 'THB',
        change: 1.50,
        percentChange: 1.40,
        high: 109.00,
        low: 107.00,
        open: 107.00,
        previousClose: 107.00,
        ceiling: 118.00,
        floor: 97.00,
      ),
      'BBL': const Stock(
        symbol: 'BBL',
        currentPrice: 145.00,
        currency: 'THB',
        change: -2.00,
        percentChange: -1.36,
        high: 147.00,
        low: 144.50,
        open: 146.50,
        previousClose: 147.00,
        ceiling: 162.00,
        floor: 132.00,
      ),
      'DELTA': const Stock(
        symbol: 'DELTA',
        currentPrice: 52.25,
        currency: 'THB',
        change: 1.25,
        percentChange: 2.45,
        high: 52.50,
        low: 51.00,
        open: 51.00,
        previousClose: 51.00,
        ceiling: 56.00,
        floor: 46.00,
      ),
      'TRUE': const Stock(
        symbol: 'TRUE',
        currentPrice: 5.85,
        currency: 'THB',
        change: -0.10,
        percentChange: -1.68,
        high: 6.00,
        low: 5.80,
        open: 5.95,
        previousClose: 5.95,
        ceiling: 6.55,
        floor: 5.35,
      ),
      'INTUCH': const Stock(
        symbol: 'INTUCH',
        currentPrice: 68.50,
        currency: 'THB',
        change: 0.50,
        percentChange: 0.74,
        high: 69.00,
        low: 68.00,
        open: 68.00,
        previousClose: 68.00,
        ceiling: 75.00,
        floor: 62.00,
      ),
    };
  }

  // Mock Order Book
  static OrderBook getMockOrderBook() {
    return const OrderBook(
      bids: [
        OrderBookEntry(volume: 200, price: 4.82),
        OrderBookEntry(volume: 200, price: 4.80),
        OrderBookEntry(volume: 1000, price: 4.70),
        OrderBookEntry(volume: 2000, price: 4.64),
        OrderBookEntry(volume: 2000, price: 4.60),
      ],
      offers: [
        OrderBookEntry(volume: 8200, price: 4.84),
        OrderBookEntry(volume: 20900, price: 4.86),
        OrderBookEntry(volume: 20000, price: 4.88),
        OrderBookEntry(volume: 500, price: 4.90),
        OrderBookEntry(volume: 1200, price: 5.00),
      ],
    );
  }

  // Mock Order Book with 10 levels
  static OrderBook getMockOrderBook10Levels() {
    return const OrderBook(
      bids: [
        OrderBookEntry(volume: 200, price: 4.82),
        OrderBookEntry(volume: 200, price: 4.80),
        OrderBookEntry(volume: 1000, price: 4.70),
        OrderBookEntry(volume: 2000, price: 4.64),
        OrderBookEntry(volume: 2000, price: 4.60),
        OrderBookEntry(volume: 500, price: 4.58),
        OrderBookEntry(volume: 1500, price: 4.56),
        OrderBookEntry(volume: 3000, price: 4.54),
        OrderBookEntry(volume: 1000, price: 4.52),
        OrderBookEntry(volume: 2500, price: 4.50),
      ],
      offers: [
        OrderBookEntry(volume: 8200, price: 4.84),
        OrderBookEntry(volume: 20900, price: 4.86),
        OrderBookEntry(volume: 20000, price: 4.88),
        OrderBookEntry(volume: 500, price: 4.90),
        OrderBookEntry(volume: 1200, price: 5.00),
        OrderBookEntry(volume: 800, price: 5.02),
        OrderBookEntry(volume: 1500, price: 5.04),
        OrderBookEntry(volume: 2000, price: 5.06),
        OrderBookEntry(volume: 1000, price: 5.08),
        OrderBookEntry(volume: 3000, price: 5.10),
      ],
    );
  }

  // Mock Portfolio Positions (empty by default)
  static List<PortfolioPosition> getMockPortfolio({bool withData = false}) {
    if (!withData) return [];

    return const [
      PortfolioPosition(
        symbol: 'AAPL',
        quantity: 100,
        averagePrice: 150.00,
        currentPrice: 155.50,
        unrealizedPL: 5.50,
        unrealizedPLPercent: 3.67,
      ),
      PortfolioPosition(
        symbol: 'TSLA',
        quantity: 50,
        averagePrice: 250.00,
        currentPrice: 245.00,
        unrealizedPL: -5.00,
        unrealizedPLPercent: -2.00,
      ),
      PortfolioPosition(
        symbol: 'NVDA',
        quantity: 75,
        averagePrice: 450.00,
        currentPrice: 475.00,
        unrealizedPL: 25.00,
        unrealizedPLPercent: 5.56,
      ),
    ];
  }

  // Mock Calendar Events (October 2025)
  static List<CalendarEvent> getMockCalendarEvents() {
    final events = <CalendarEvent>[];

    // Add events for dates with orange dots
    final eventDates = [
      1,
      2,
      3,
      6,
      7,
      8,
      9,
      10,
      14,
      15,
      16,
      20,
      21,
      22,
      24,
      28,
      30,
      31,
    ];

    for (final day in eventDates) {
      events.add(
        CalendarEvent(
          date: DateTime(2025, 10, day),
          type: 'dividend',
          stocks: day == 28
              ? ['ASML01', 'INETREIT']
              : ['STOCK${day.toString().padLeft(2, '0')}'],
          description: 'Ex-Dividend Date',
        ),
      );
    }

    return events;
  }

  // Mock News Articles
  static List<Article> getMockArticles() {
    final now = DateTime.now();

    return [
      Article(
        id: 'article_001',
        title: '📝 5 Key Takeaways จาก LIB Talks Live วันนี้ --28/10/68',
        preview:
            '1. ตลาดหุ้นสหรัฐฯ เข้าสู่ภาวะ Risk On เต็มตัว ตลาดหุ้นสหรัฐฯ ปรับตัวขึ้นทำ New High พร้อมกันทั้ง 3 ตลาด ได้แก่ Nasd...',
        timestamp: now.subtract(const Duration(hours: 3)),
        icon: '📝',
        content: 'Full article content about market analysis...',
      ),
      Article(
        id: 'article_002',
        title: '💙 สรป 10 หุ้นต้องรู้ จาก Live LIB Talks วันนี้ --28/10/68',
        preview: '1. DELTA\n\nไตรมาส 4 คาดว่า...',
        timestamp: now.subtract(const Duration(hours: 3)),
        icon: '💙',
        content: 'Top 10 stocks analysis...',
      ),
      Article(
        id: 'article_003',
        title: '📝 5 Key Takeaways จาก LIB Talks Live วันนี้ --22/10/68',
        preview: '1. มติ ครม. ยังเป็นความหวัง\n\nที่ประชุมคณะรัฐมนตรี...',
        timestamp: now.subtract(const Duration(days: 6)),
        icon: '📝',
        content: 'Cabinet resolution analysis...',
      ),
      Article(
        id: 'article_004',
        title: '💙 สรป 10 หุ้นต้องรู้ จาก Live LIB Talks วันนี้ --22/10/68',
        preview: 'รวมหุ้นน่าสนใจประจำวัน...',
        timestamp: now.subtract(const Duration(days: 6)),
        icon: '💙',
        content: 'Daily stock picks...',
      ),
      Article(
        id: 'article_005',
        title: '📝 ตลาดหุ้นไทยปรับฐาน แนวโน้มระยะสั้น',
        preview: 'SET Index ปรับตัวลง ติดตามปัจจัยต่างประเทศ...',
        timestamp: now.subtract(const Duration(days: 10)),
        icon: '📝',
        content: 'Thai stock market outlook...',
      ),
    ];
  }

  // Mock Stock Symbols for Search
  static List<String> getMockStockSymbols() {
    return [
      'A',
      'AAPL',
      'ASML01',
      'DELTA',
      'INETREIT',
      'NVDR',
      'PTT',
      'KBANK',
      'SCB',
      'BBL',
      'CPALL',
      'AOT',
      'ADVANC',
      'TRUE',
      'INTUCH',
    ];
  }

  // Mock Notifications
  static List<AppNotification> getMockNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: '1',
        title: 'แจ้งเตือน มีการเปลี่ยนชื่อหุ้นในระบบเทรด',
        message: 'การเปลี่ยนแปลงชื่อย่อหลักทรัพย์ของ 24CS',
        timestamp: DateTime(now.year, now.month, now.day, 6, 0, 21),
        isRead: false,
        icon: '📄',
      ),
      AppNotification(
        id: '2',
        title: 'Market Update',
        message: 'SET Index reached 1,320 points',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
        icon: '📈',
      ),
      AppNotification(
        id: '3',
        title: 'Dividend Announcement',
        message: 'ADVANC declared dividend payment',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        icon: '💰',
      ),
      AppNotification(
        id: '4',
        title: 'Trading Alert',
        message: 'PTT price reached your target level',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        icon: '🔔',
      ),
      AppNotification(
        id: '5',
        title: 'Account Notice',
        message: 'Your monthly statement is ready',
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
        icon: '📊',
      ),
    ];
  }
}
