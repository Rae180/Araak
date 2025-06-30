import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/Wallet/Bloc/Wallet_bloc/wallet_bloc.dart';
import 'package:start/features/Wallet/view/Screens/TopUpScreen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletScreen extends StatelessWidget {
  static const String routeName = '/Wallet_screen';
  const WalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc(client: NetworkApiServiceHttp())
        ..add(GetWalletBalanceEvent()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.mywallet,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          backgroundColor: Colors.transparent,
          iconTheme:
              IconThemeData(color: Theme.of(context).colorScheme.onSurface),
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: _WalletBody(),
      ),
    );
  }
}

class _WalletBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.sectionPadding),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Animated Balance Card
          _BalanceCard(),
          const SizedBox(height: 40),
          // Top-up button
          _TopUpButton(l10n: l10n),
          const SizedBox(height: 30),
          // Transaction history
          _TransactionHistory(l10n: l10n),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  colorScheme.primaryContainer,
                  colorScheme.primaryContainer.withOpacity(0.8),
                  colorScheme.secondaryContainer,
                ]
              : [
                  colorScheme.surface,
                  colorScheme.surface,
                ],
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            right: -40,
            top: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 15,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                painter: _DashedLinePainter(color: colorScheme.outline),
              ),
            ),
          ),
          // Balance content
          Center(
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return _buildLoadingState(colorScheme);
                } else if (state is WalletBalanceSuccess) {
                  return _buildBalanceState(context, state, colorScheme);
                } else if (state is WalletErrorState) {
                  return _buildErrorState(state, colorScheme);
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Loading balance...',
          style: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildBalanceState(BuildContext context, WalletBalanceSuccess state,
      ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.currentbalance,
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBalanceText(
          balance: double.tryParse(state.wallet.balance!) ?? 0.0,
          color: colorScheme.onSurface,
        ),
      ],
    );
  }

  Widget _buildErrorState(WalletErrorState state, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 40,
          color: colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'Error: ${state.message}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colorScheme.error,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class AnimatedBalanceText extends StatefulWidget {
  final double balance;
  final Color color;

  const AnimatedBalanceText({
    Key? key,
    required this.balance,
    required this.color,
  }) : super(key: key);

  @override
  State<AnimatedBalanceText> createState() => _AnimatedBalanceTextState();
}

class _AnimatedBalanceTextState extends State<AnimatedBalanceText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _displayBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: _displayBalance,
      end: widget.balance,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedBalanceText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.balance != widget.balance) {
      _animation = Tween<double>(
        begin: _displayBalance,
        end: widget.balance,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        _displayBalance = _animation.value;
        return Text(
          '\$${_displayBalance.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: widget.color,
            letterSpacing: 1.2,
          ),
        );
      },
    );
  }
}

class _TopUpButton extends StatelessWidget {
  final AppLocalizations l10n;

  const _TopUpButton({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, TopUpScreen.routeName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardRadius)),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: colorScheme.onPrimary),
            const SizedBox(width: 10),
            Text(
              l10n.topupbal,
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionHistory extends StatelessWidget {
  final AppLocalizations l10n;

  const _TransactionHistory({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              l10n.recentact,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return _buildTransactionShimmer(colorScheme);
                } else if (state is WalletBalanceSuccess) {
                  //  return _buildTransactionList(state);
                } else if (state is WalletErrorState) {
                  return Center(
                    child: Text(
                      'No transactions available',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionShimmer(ColorScheme colorScheme) {
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: colorScheme.outline.withOpacity(0.1),
      ),
      itemBuilder: (context, index) => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorScheme.surfaceVariant,
          ),
        ),
        title: Container(
          width: 100,
          height: 16,
          color: colorScheme.surfaceVariant,
        ),
        subtitle: Container(
          width: 80,
          height: 12,
          color: colorScheme.surfaceVariant,
        ),
        trailing: Container(
          width: 60,
          height: 16,
          color: colorScheme.surfaceVariant,
        ),
      ),
    );
  }
}

//   Widget _buildTransactionList(WalletBalanceSuccess state) {
//     final transactions = state.wallet.transactions ?? [];
//     final hasTransactions = transactions.isNotEmpty;

//     return hasTransactions
//         ? ListView.separated(
//             physics: const BouncingScrollPhysics(),
//             itemCount: transactions.length,
//             separatorBuilder: (context, index) => Divider(
//               height: 1,
//               color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
//             ),
//             itemBuilder: (context, index) => _TransactionItem(
//               transaction: transactions[index],
//             ),
//           )
//         : Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.history,
//                   size: 60,
//                   color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'No transactions yet',
//                   style: TextStyle(
//                     color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }

// class _TransactionItem extends StatelessWidget {
//   final Transaction transaction;

//   const _TransactionItem({required this.transaction});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
//     final isCredit = transaction.type == 'credit';

//     return ListTile(
//       contentPadding: EdgeInsets.zero,
//       leading: Container(
//         width: 50,
//         height: 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isCredit
//               ? colorScheme.primaryContainer
//               : colorScheme.errorContainer,
//         ),
//         child: Icon(
//           isCredit ? Icons.arrow_downward : Icons.arrow_upward,
//           color: isCredit ? colorScheme.primary : colorScheme.error,
//         ),
//       ),
//       title: Text(
//         transaction.description ?? (isCredit ? 'Top Up' : 'Payment'),
//         style: theme.textTheme.bodyLarge?.copyWith(
//           fontWeight: FontWeight.bold,
//           color: colorScheme.onSurface,
//         ),
//       ),
//       subtitle: Text(
//         transaction.date ?? 'Unknown date',
//         style: theme.textTheme.bodyMedium?.copyWith(
//           color: colorScheme.onSurface.withOpacity(0.6),
//         ),
//       ),
//       trailing: Text(
//         '${isCredit ? '+' : '-'}\$${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
//         style: theme.textTheme.titleMedium?.copyWith(
//           color: isCredit ? colorScheme.primary : colorScheme.error,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

// Custom painter for dashed line decoration
class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, ui.Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
