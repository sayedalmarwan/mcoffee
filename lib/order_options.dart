import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  final String coffeeName;
  final String imagePath;
  final double price;
  final List<Map<String, dynamic>> cartItems;

  const OrderPage({
    super.key,
    required this.coffeeName,
    required this.imagePath,
    required this.price,
    required this.cartItems,
  });

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int quantity = 1;
  String serviceType = 'Onsite';
  String volume = '350';

  double get priceMultiplier => switch (volume) {
        '250' => 1.0,
        '350' => 1.2,
        '450' => 1.4,
        _ => 1.0,
      };

  double get totalPrice => widget.price * quantity * priceMultiplier;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.coffeeName,
          style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageSection(colorScheme),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPriceAndQuantity(colorScheme, textTheme),
                        const SizedBox(height: 32),
                        _buildServiceType(colorScheme),
                        const SizedBox(height: 32),
                        _buildVolumeSelection(colorScheme),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomSection(colorScheme),
        ],
      ),
    );
  }

  Widget _buildImageSection(ColorScheme colorScheme) => Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        padding: const EdgeInsets.all(32),
        child: Hero(
          tag: widget.coffeeName,
          child: Image.asset(widget.imagePath, fit: BoxFit.contain),
        ),
      );

  Widget _buildPriceAndQuantity(ColorScheme colorScheme, TextTheme textTheme) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price',
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: colorScheme.onPrimaryContainer),
                  onPressed: () {
                    if (quantity > 1) setState(() => quantity--);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: colorScheme.onPrimaryContainer),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildServiceType(ColorScheme colorScheme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildServiceTypeButton('Onsite', Icons.coffee, serviceType == 'Onsite', colorScheme),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildServiceTypeButton(
                    'Takeaway', Icons.takeout_dining_outlined, serviceType == 'Takeaway', colorScheme),
              ),
            ],
          ),
        ],
      );

  Widget _buildServiceTypeButton(String type, IconData icon, bool isSelected, ColorScheme colorScheme) =>
      Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => serviceType = type),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primaryContainer
                  : Color.lerp(colorScheme.surfaceContainerHighest, colorScheme.primaryContainer, 0.3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  size: 28,
                ),
                const SizedBox(height: 8),
                Text(
                  type,
                  style: TextStyle(
                    color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildVolumeSelection(ColorScheme colorScheme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Volume',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var vol in ['250', '350', '450'])
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: vol == '250' ? 0 : 8,
                      right: vol == '450' ? 0 : 8,
                    ),
                    child: _buildVolumeOption(vol, colorScheme),
                  ),
                ),
            ],
          ),
        ],
      );

  Widget _buildVolumeOption(String vol, ColorScheme colorScheme) {
    final isSelected = volume == vol;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => volume = vol),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer
                : Color.lerp(colorScheme.surfaceContainerHighest, colorScheme.primaryContainer, 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Text(
            '$vol ml',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(ColorScheme colorScheme) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
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
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 14, color: colorScheme.onPrimary.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                ),
              ],
            ),
            FilledButton.icon(
              onPressed: () {
                widget.cartItems.add({
                  "name": widget.coffeeName,
                  "price": totalPrice,
                  "image": widget.imagePath,
                });
                Navigator.pop(context, true);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: colorScheme.surface,
                foregroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text(
                'Add to Cart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
}
