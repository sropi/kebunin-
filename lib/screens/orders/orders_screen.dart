import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/constants.dart';
import '../../app/routes.dart';
import '../../models/order.dart';
import '../../services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  final bool isRootTab;

  const OrdersScreen({super.key, this.isRootTab = false});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'Semua',
    'Diproses',
    'Dikirim',
    'Selesai',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> _getFilteredOrders(List<Order> allOrders, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return allOrders
            .where((o) => o.status == OrderStatus.diproses)
            .toList();
      case 2:
        return allOrders
            .where((o) => o.status == OrderStatus.dikirim)
            .toList();
      case 3:
        return allOrders
            .where((o) => o.status == OrderStatus.selesai)
            .toList();
      default:
        return allOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderService = context.watch<OrderService>();
    final allOrders = orderService.orders;

    return Scaffold(
      backgroundColor: KebuninColors.warmCream,
      appBar: AppBar(
        backgroundColor: KebuninColors.white,
        elevation: 0,
        leading: !widget.isRootTab && Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: KebuninColors.charcoal),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: KebuninColors.charcoal,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: KebuninColors.forestGreen,
          unselectedLabelColor: KebuninColors.mutedGrey,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          indicatorColor: KebuninColors.forestGreen,
          indicatorWeight: 3,
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (index) {
          final orders = _getFilteredOrders(allOrders, index);

          if (orders.isEmpty) {
            return RefreshIndicator(
              color: KebuninColors.forestGreen,
              onRefresh: () => orderService.fetchOrders(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: _buildEmptyState(),
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: KebuninColors.forestGreen,
            onRefresh: () => orderService.fetchOrders(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 14),
              itemBuilder: (context, idx) {
                final order = orders[idx];
                return _buildOrderCard(context, order);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return Container(
      decoration: BoxDecoration(
        color: KebuninColors.white,
        borderRadius: BorderRadius.circular(KebuninRadius.md),
        border: Border.all(color: KebuninColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.orderDetail,
              arguments: order,
            );
          },
          borderRadius: BorderRadius.circular(KebuninRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Number & Status Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.receipt_outlined,
                            size: 16, color: KebuninColors.forestGreen),
                        const SizedBox(width: 6),
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: KebuninColors.charcoal,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: order.status.backgroundColor,
                        borderRadius:
                            BorderRadius.circular(KebuninRadius.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(order.status.icon,
                              size: 12, color: order.status.color),
                          const SizedBox(width: 4),
                          Text(
                            order.status.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: order.status.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order.formattedCreatedAt,
                  style: const TextStyle(
                    fontSize: 11,
                    color: KebuninColors.mutedGrey,
                  ),
                ),
                const Divider(height: 18),

                // First Item Thumbnail & Summary
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(KebuninRadius.sm),
                      child: Image.network(
                        order.items.first.product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.items.first.product.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: KebuninColors.charcoal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${order.items.first.quantity}x ${order.items.first.product.formattedPrice}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: KebuninColors.mutedGrey,
                            ),
                          ),
                          if (order.items.length > 1) ...[
                            const SizedBox(height: 2),
                            Text(
                              '+ ${order.items.length - 1} sayur lainnya',
                              style: const TextStyle(
                                fontSize: 11,
                                color: KebuninColors.forestGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const Divider(height: 18),

                // Total Price & Track Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Belanja',
                          style: TextStyle(
                            fontSize: 11,
                            color: KebuninColors.mutedGrey,
                          ),
                        ),
                        Text(
                          order.formattedTotal,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: KebuninColors.forestGreen,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: KebuninColors.warmCream,
                        borderRadius:
                            BorderRadius.circular(KebuninRadius.pill),
                        border: Border.all(color: KebuninColors.border),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Lihat Detail',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: KebuninColors.forestGreen,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios_rounded,
                              size: 10, color: KebuninColors.forestGreen),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: KebuninColors.white,
                shape: BoxShape.circle,
                border: Border.all(color: KebuninColors.border),
              ),
              child: const Icon(
                Icons.assignment_outlined,
                size: 40,
                color: KebuninColors.mutedGrey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Belum Ada Pesanan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: KebuninColors.charcoal,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Sayur yang Anda pesan akan tercatat rapi di sini.',
              style: TextStyle(
                fontSize: 13,
                color: KebuninColors.mutedGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
