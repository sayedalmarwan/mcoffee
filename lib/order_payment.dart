import 'package:flutter/material.dart';
import 'package:mcoffee/confirmed_page.dart';
import 'package:mcoffee/menu.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderPaymentPage extends StatefulWidget {
  final double totalAmount;
  final Map<String, dynamic> selectedStore;

  const OrderPaymentPage({
    super.key,
    required this.totalAmount,
    required this.selectedStore,
  });

  @override
  State<OrderPaymentPage> createState() => _OrderPaymentPageState();
}

class _OrderPaymentPageState extends State<OrderPaymentPage> {
  late final Razorpay _razorpay;
  String selectedPaymentMethod = "Online Payment";
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    MenuPage.cartItems.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
      (route) => false,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showMessage("Payment Failed: ${response.message ?? 'Error occurred'}");
    setState(() => isProcessing = false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showMessage("Processing with ${response.walletName}");
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _processPayment() async {
    if (isProcessing) return;

    setState(() => isProcessing = true);

    try {
      if (!mounted) return;
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;

      MenuPage.cartItems.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OrderConfirmationScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      _showMessage("Error processing payment: $e");
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: !isProcessing,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && isProcessing) {
          _showMessage("Please wait while processing payment");
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          title: const Text('Payment'),
          centerTitle: true,
          leading: isProcessing
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildOrderSummary(theme),
                    const SizedBox(height: 32),
                    _buildPaymentMethods(theme),
                  ],
                ),
              ),
            ),
            _buildBottomBar(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(ThemeData theme) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'Order Summary',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.storefront_outlined, color: theme.colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedStore['name'],
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.selectedStore['location'], style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildPaymentMethods(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                'Payment Method',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPaymentOption('Online Payment', 'assets/images/upi.png', theme),
          const SizedBox(height: 12),
          _buildPaymentOption('Credit/Debit Card', 'assets/images/card.png', theme),
        ],
      );

  Widget _buildPaymentOption(String title, String asset, ThemeData theme) {
    final isSelected = selectedPaymentMethod == title;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => selectedPaymentMethod = title),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Image.asset(asset, width: 48, height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${widget.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: isProcessing ? null : _processPayment,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: theme.colorScheme.surface,
                foregroundColor: theme.colorScheme.primary,
                disabledBackgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                disabledForegroundColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: isProcessing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    )
                  : const Icon(Icons.lock_outline, size: 20),
              label: Text(
                isProcessing ? 'Processing...' : 'Pay Securely',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
}
