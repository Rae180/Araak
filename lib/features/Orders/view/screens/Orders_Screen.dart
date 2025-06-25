import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Orders/Bloc/bloc/orders_bloc.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/Orders_screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String _formatDuration(String durationString) {
  // Parse the string into a Duration object
  Duration d;
  try {
    if (durationString.contains(':')) {
      // Handle "HH:MM:SS" format
      List<String> parts = durationString.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;
      d = Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      // Handle seconds as integer string
      int seconds = int.parse(durationString);
      d = Duration(seconds: seconds);
    }
  } catch (e) {
    return 'Invalid duration';
  }

  // Original formatting logic
  if (d.inHours > 24) {
    return '${d.inDays}d ${d.inHours.remainder(24)}h left';
  } else if (d.inMinutes > 60) {
    return '${d.inHours}h ${d.inMinutes.remainder(60)}m left';
  } else if (d.inMinutes > 0) {
    return '${d.inMinutes}m left';
  }
  return 'Completed';
}

  Color _getStatusColor(String? status) {
    switch (status!.toLowerCase()) {
      case 'processing':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Cancel order function
  void _cancelOrder(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel ${index}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${index} cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersBloc(client: NetworkApiServiceHttp())..add(GetAllOrdersEvent()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Orders',
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is AllOrdersSuucess) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.orders!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = state.orders.orders![index];
                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Order ID and Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${order.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(order.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  order.status!,
                                  style: TextStyle(
                                    color: _getStatusColor(order.status),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Date and Time
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(order.remainingTime as DateTime),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const Spacer(),
                              const Icon(Icons.access_time,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                _formatDuration(order.remainingTime!),
                                style: TextStyle(
                                  color: order.remainingTime! == '0:0:0'
                                      ? Colors.blue
                                      : Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Cancel button (only for non-delivered orders)
                          if (order.status != 'Delivered') ...[
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: () => _cancelOrder(index),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                icon: const Icon(Icons.close, size: 18),
                                label: const Text('Cancel Order'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is OrdersError) {
              return Center(
                child: Text(state.message),
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
