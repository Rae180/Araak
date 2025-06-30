import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/Orders/Bloc/bloc/orders_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/Orders_screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final Map<int, bool> _expandedStates = {};

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatDuration(BuildContext context, String? durationString) {
    if (durationString == null || durationString.isEmpty)
      return 'AppLocalizations.of(context)!.completed';

    try {
      Duration d;
      if (durationString.contains(':')) {
        List<String> parts = durationString.split(':');
        int hours = int.parse(parts[0]);
        int minutes = int.parse(parts[1]);
        int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;
        d = Duration(hours: hours, minutes: minutes, seconds: seconds);
      } else {
        int seconds = int.parse(durationString);
        d = Duration(seconds: seconds);
      }

      final l10n = AppLocalizations.of(context)!;

      if (d.inHours > 24) {
        return '${d.inDays}${'l10n.days'} ${d.inHours.remainder(24)}${'l10n.hours'} ${'l10n.left'}';
      } else if (d.inHours > 0) {
        return '${d.inHours}${'l10n.hours'} ${d.inMinutes.remainder(60)}${'l10n.minutes'} ${'l10n.left'}';
      } else if (d.inMinutes > 0) {
        return '${d.inMinutes}${'l10n.minutes'} ${'l10n.left'}';
      }
      return 'l10n.completed';
    } catch (e) {
      return 'AppLocalizations.of(context)!.invalidDuration';
    }
  }

  Color _getStatusColor(String? status, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (status?.toLowerCase()) {
      case 'processing':
        return colorScheme.primary;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return colorScheme.tertiary ?? Colors.green;
      case 'cancelled':
        return colorScheme.error;
      default:
        return colorScheme.onSurface.withOpacity(0.3);
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'processing':
        return Icons.hourglass_top;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  void _cancelOrder(int orderId, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('l10n.cancelOrder'),
        content: Text('l10n.cancelOrderConfirm(orderId.toString())'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('l10n.no'),
          ),
          TextButton(
            onPressed: () {
              //  context.read<OrdersBloc>().add(CancelOrderEvent(orderId: orderId));
              Navigator.pop(context);
            },
            child: Text(l10n.yes,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  void _toggleExpand(int index) {
    setState(() {
      _expandedStates[index] = !(_expandedStates[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) =>
          OrdersBloc(client: NetworkApiServiceHttp())..add(GetAllOrdersEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('l10n.orders', style: theme.textTheme.titleLarge),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: BlocConsumer<OrdersBloc, OrdersState>(
          listener: (context, state) {
            // if (state is CancelOrderSuccess) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(l10n.orderCancelled(state.orderId.toString())),
            //       backgroundColor: colorScheme.tertiary,
            //     ),
            //   );
            // } else if (state is OrdersError) {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(state.message),
            //       backgroundColor: colorScheme.error,
            //     ),
            //   );
            // }
          },
          builder: (context, state) {
            if (state is OrdersLoading) {
              return _buildLoadingState(colorScheme);
            } else if (state is AllOrdersSuucess) {
              return _buildOrderList(context, state, l10n, colorScheme);
            } else if (state is OrdersError) {
              return _buildErrorState(context, state, l10n, colorScheme);
            }
            // else if (state is OrdersEmpty) {
            //   return _buildEmptyState(context, l10n, colorScheme);
            // }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: 5,
      itemBuilder: (context, index) => _buildShimmerOrderCard(colorScheme),
    );
  }

  Widget _buildShimmerOrderCard(ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.elementSpacing),
      elevation: 0,
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.elementSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 80,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, AllOrdersSuucess state,
      AppLocalizations l10n, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    if (state.orders.orders == null || state.orders.orders!.isEmpty) {
      return _buildEmptyState(context, l10n, colorScheme);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: state.orders.orders!.length,
      itemBuilder: (context, index) {
        final order = state.orders.orders![index];
        final isExpanded = _expandedStates[index] ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.elementSpacing),
          elevation: 0,
          color: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: InkWell(
            onTap: () => _toggleExpand(index),
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.elementSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${order.id}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status, context)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getStatusIcon(order.status),
                              size: 16,
                              color: _getStatusColor(order.status, context),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              order.status ?? 'l10n.unknownStatus',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: _getStatusColor(order.status, context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Order details
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18,
                          color: colorScheme.onSurface.withOpacity(0.6)),
                      const SizedBox(width: 8),
                      Text(
                        'DateFormat.yMMMd().add_jm().format(order.orderDate ?? DateTime.now()',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.access_time,
                          size: 18,
                          color: colorScheme.onSurface.withOpacity(0.6)),
                      const SizedBox(width: 8),
                      Text(
                        _formatDuration(context, order.remainingTime),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: order.status?.toLowerCase() == 'delivered'
                              ? colorScheme.tertiary
                              : colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  // Expandable content
                  if (isExpanded) ...[
                    const SizedBox(height: 16),
                    Divider(
                        height: 1, color: colorScheme.outline.withOpacity(0.2)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.total,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                '\$${'order.totalPrice?.toStringAsFixed(2)' ?? "0.00"}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'l10n.items',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                              Text(
                                'order.itemsCount ?? 0 ${'l10n.items'}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Cancel button
                  if (order.status?.toLowerCase() != 'delivered' &&
                      order.status?.toLowerCase() != 'cancelled') ...[
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () => _cancelOrder(order.id!, context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                        ),
                        icon: Icon(Icons.close, size: 18),
                        label: Text('l10n.cancelOrder'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, OrdersError state,
      AppLocalizations l10n, ColorScheme colorScheme) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.sectionPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 24),
            Text(
              'l10n.errorLoadingOrders',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  context.read<OrdersBloc>().add(GetAllOrdersEvent()),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('l10n.retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, AppLocalizations l10n, ColorScheme colorScheme) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.sectionPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 80,
              color: colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'l10n.noOrders',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'l10n.noOrdersDesc',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('l10n.startShopping'),
            ),
          ],
        ),
      ),
    );
  }
}
