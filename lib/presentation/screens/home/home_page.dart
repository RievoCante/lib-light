// Home page with calendar and corporate actions
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../localization/app_localizations.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/market_header.dart';
import '../../widgets/common/notification_bell.dart';
import '../../widgets/common/profile_avatar.dart';
import '../notification/notification_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final todayEvents = ref
        .read(calendarProvider.notifier)
        .getEventsForDate(_selectedDay ?? _focusedDay);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(child: const MarketHeader(showLogo: true)),
                  Consumer(
                    builder: (context, ref, child) {
                      final unreadCount = ref.watch(
                        unreadNotificationCountProvider,
                      );
                      return NotificationBell(
                        hasNotifications: unreadCount > 0,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  ProfileAvatar(
                    onTap: () {
                      // Navigate to settings
                    },
                  ),
                ],
              ),
            ),

            // Calendar Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                  Text(l10n.calendar, style: AppTextStyles.h2),
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Calendar
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month/Year
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getMonthName(_focusedDay.month),
                            style: AppTextStyles.h2,
                          ),
                          Text(
                            '${_focusedDay.year}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Calendar widget
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: TableCalendar(
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        calendarFormat: CalendarFormat.month,
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        headerVisible: false,
                        calendarStyle: CalendarStyle(
                          defaultTextStyle: AppTextStyles.bodyMedium,
                          weekendTextStyle: AppTextStyles.bodyMedium,
                          selectedDecoration: const BoxDecoration(
                            color: AppColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: const BoxDecoration(
                            color: AppColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                          markerDecoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                          outsideTextStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          weekendStyle: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        eventLoader: (day) {
                          final hasEvent = ref
                              .read(calendarProvider.notifier)
                              .hasEventsOnDate(day);
                          return hasEvent ? ['event'] : [];
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Today's Events
                    Text(
                      '${_getMonthName(_selectedDay?.month ?? _focusedDay.month)} ${_selectedDay?.day ?? _focusedDay.day}, ${_selectedDay?.year ?? _focusedDay.year} / ${l10n.today}',
                      style: AppTextStyles.bodyMedium,
                    ),

                    const SizedBox(height: 16),

                    // Corporate Actions
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.corporateActions,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Stock symbols with XD badges
                    if (todayEvents.isNotEmpty)
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: todayEvents.expand((event) {
                          return event.stocks.map((stock) {
                            return _buildStockBadge(stock);
                          });
                        }).toList(),
                      )
                    else
                      Text(
                        l10n.noCorporateActions,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockBadge(String symbol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.badgeBlue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'XD',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(symbol, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
