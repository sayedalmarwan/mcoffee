import 'package:flutter/material.dart';
import 'package:mcoffee/order_options.dart';
import 'package:mcoffee/order_payment.dart';
import 'package:mcoffee/profile.dart';
import 'package:mcoffee/theme.dart';

class MenuPage extends StatefulWidget {
  final Map<String, dynamic> selectedStore;
  static List<Map<String, dynamic>> cartItems = [];

  const MenuPage({super.key, required this.selectedStore});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> menuItems = const [
    {
      'name': 'Americano',
      'price': 3.99,
      'image': 'assets/images/americano.png'
    },
    {
      'name': 'Cappuccino',
      'price': 4.99,
      'image': 'assets/images/cappuccino.png'
    },
    {
      'name': 'Flat White',
      'price': 3.99,
      'image': 'assets/images/flat_white.png'
    },
    {'name': 'Espresso', 'price': 3.49, 'image': 'assets/images/espresso.png'},
    {'name': 'Latte', 'price': 4.49, 'image': 'assets/images/latte.png'},
    {'name': 'Raf', 'price': 3.49, 'image': 'assets/images/raf.png'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double get _total => MenuPage.cartItems
      .fold(0, (sum, item) => sum + (item['price'] as double));

  void _onItemTap(Map<String, dynamic> item) {
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => OrderPage(
          coffeeName: item['name'],
          imagePath: item['image'],
          price: item['price'],
          cartItems: MenuPage.cartItems,
        ),
      ),
    ).then((added) {
      if (added == true) {
        _controller.forward().then((_) => _controller.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final commonDecoration = BoxDecoration(
      color: theme.colorScheme.primary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    );

    return AppWithSwipeBack(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.selectedStore['name']),
              Text(widget.selectedStore['location'],
                  style: theme.textTheme.bodyMedium),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    userName: "Alex",
                    userEmail: "adosmenesk@pm.me",
                    userPhone: "+375 33 664-57-36",
                    storeAddress: widget.selectedStore['location'],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [_buildMenuTab(), _buildCartTab()],
        ),
        bottomNavigationBar: Container(
          decoration: commonDecoration,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(color: Colors.white),
              ),
            ),
            child: NavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 65,
              indicatorColor: Colors.white.withValues(alpha: 0.2),
              selectedIndex: _selectedIndex,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined,
                      color: Colors.white.withValues(alpha: 0.8)),
                  selectedIcon:
                      const Icon(Icons.storefront, color: Colors.white),
                  label: "Menu",
                ),
                NavigationDestination(
                  icon: ScaleTransition(
                    scale: _animation,
                    child: Icon(Icons.shopping_cart_outlined,
                        color: Colors.white.withValues(alpha: 0.8)),
                  ),
                  selectedIcon:
                      const Icon(Icons.shopping_cart, color: Colors.white),
                  label: "Cart",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTab() => GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) => _buildMenuItem(menuItems[index]),
      );

  Widget _buildMenuItem(Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _onItemTap(item),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Hero(
                tag: item['name'],
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.asset(item['image'], fit: BoxFit.contain),
                ),
              ),
            ),
            Text(
              item['name'],
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${item['price'].toStringAsFixed(2)}',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTab() {
    if (MenuPage.cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text('Your cart is empty',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Add items from the menu',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            itemCount: MenuPage.cartItems.length,
            itemBuilder: (context, index) => Dismissible(
              key: ValueKey(index),
              direction: DismissDirection.endToStart,
              onDismissed: (_) =>
                  setState(() => MenuPage.cartItems.removeAt(index)),
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset(MenuPage.cartItems[index]['image'],
                            fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              MenuPage.cartItems[index]['name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${MenuPage.cartItems[index]['price'].toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error),
                        onPressed: () =>
                            setState(() => MenuPage.cartItems.removeAt(index)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderPaymentPage(
                        totalAmount: _total,
                        selectedStore: widget.selectedStore,
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_checkout_outlined),
                label: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
