// Buy/Sell modal - simple and beginner-friendly
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/stock_list_item.dart';

class BuySellModal extends StatefulWidget {
  final StockListItem stockItem;
  final bool isBuying;

  const BuySellModal({
    super.key,
    required this.stockItem,
    required this.isBuying,
  });

  @override
  State<BuySellModal> createState() => _BuySellModalState();
}

class _BuySellModalState extends State<BuySellModal> {
  final _amountController = TextEditingController();
  final _focusNode = FocusNode();

  // Mock user balance
  final double _userBalance = 50000.00; // THB

  double get _amountTHB {
    final text = _amountController.text.replaceAll(',', '');
    return double.tryParse(text) ?? 0.0;
  }

  double get _quantity {
    if (_amountTHB <= 0) return 0.0;
    return _amountTHB / widget.stockItem.currentPrice;
  }

  bool get _canProceed {
    return _amountTHB > 0 && _amountTHB <= _userBalance;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    widget.isBuying
                        ? 'Buy ${widget.stockItem.symbol}'
                        : 'Sell ${widget.stockItem.symbol}',
                    style: AppTextStyles.h3,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const Divider(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Price
                  _buildInfoRow(
                    'Current Price',
                    Formatters.formatPrice(widget.stockItem.currentPrice),
                  ),

                  const SizedBox(height: 16),

                  // Amount Input
                  Text('Amount (THB)', style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '0.00',
                      prefixText: '฿ ',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _amountController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),

                  const SizedBox(height: 16),

                  // Quick Amount Buttons
                  Row(
                    children: [
                      _buildQuickAmountButton('1,000'),
                      const SizedBox(width: 8),
                      _buildQuickAmountButton('5,000'),
                      const SizedBox(width: 8),
                      _buildQuickAmountButton('10,000'),
                      const SizedBox(width: 8),
                      _buildQuickAmountButton('All', isAll: true),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Calculated Quantity
                  _buildInfoRow(
                    'You will get',
                    '${Formatters.formatNumber(_quantity)} shares',
                  ),

                  const SizedBox(height: 12),

                  // User Balance
                  _buildInfoRow(
                    'Your balance',
                    Formatters.formatPrice(_userBalance),
                  ),

                  const SizedBox(height: 24),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _canProceed ? _showConfirmation : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isBuying
                            ? AppColors.primaryBlue
                            : AppColors.negative,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.isBuying ? 'Buy' : 'Sell',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildQuickAmountButton(String label, {bool isAll = false}) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          final amount = isAll
              ? _userBalance.toStringAsFixed(0)
              : label.replaceAll(',', '');
          _amountController.text = amount;
          setState(() {});
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(label, style: AppTextStyles.bodySmall),
      ),
    );
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm ${widget.isBuying ? 'Purchase' : 'Sale'}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Stock: ${widget.stockItem.symbol}'),
            Text('Amount: ฿${Formatters.formatPrice(_amountTHB)}'),
            Text('Quantity: ${Formatters.formatNumber(_quantity)} shares'),
            Text(
              'Price: ฿${Formatters.formatPrice(widget.stockItem.currentPrice)}/share',
            ),
            const SizedBox(height: 16),
            Text(
              'Are you sure you want to ${widget.isBuying ? 'buy' : 'sell'}?',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close modal
              _showSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.isBuying
                  ? AppColors.primaryBlue
                  : AppColors.negative,
            ),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.isBuying ? 'Purchase' : 'Sale'} successful!'),
        backgroundColor: AppColors.positive,
      ),
    );
  }
}
