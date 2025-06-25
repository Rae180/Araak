import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
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
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.mywallet,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
        ),
        body: _WalletBody(),
      ),
    );
  }
}

class _WalletBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),
          // Balance Card with creative design
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10))
              ],
            ),
            child: Stack(
              children: [
                // Creative geometric pattern
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: Colors.grey.shade200, width: 15),
                    ),
                  ),
                ),
                // Diagonal lines decoration
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: SizedBox(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: _DashedLinePainter(),
                    ),
                  ),
                ),
                // Balance content
                Center(
                  child: BlocBuilder<WalletBloc, WalletState>(
                    builder: (context, state) {
                      if (state is WalletLoading) {
                        return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        );
                      } else if (state is WalletBalanceSuccess) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(AppLocalizations.of(context)!.currentbalance,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    letterSpacing: 1.5)),
                            const SizedBox(height: 12),
                            Text('\$${state.wallet.balance}',
                                style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    letterSpacing: 1.2)),
                          ],
                        );
                      } else if (state is WalletErrorState) {
                        return Text('Error: ${state.message}',
                            style: const TextStyle(color: Colors.black));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Top-up button with creative touch
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, TopUpScreen.routeName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 10),
                  Text(AppLocalizations.of(context)!.topupbal,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Decorative transaction history placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(AppLocalizations.of(context)!.recentact,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 14)),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 0),
                    itemBuilder: (context, index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index % 2 == 0
                              ? Colors.grey.shade300
                              : Colors.black,
                        ),
                        child: Icon(
                          index % 2 == 0
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: index % 2 == 0 ? Colors.black : Colors.white,
                        ),
                      ),
                      title: Text(
                        index % 2 == 0 ? 'Top Up' : 'Payment',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      subtitle: Text(
                        'Jun ${25 - index}, 2025',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: Text(
                        index % 2 == 0 ? '+\$50.00' : '-\$12.50',
                        style: TextStyle(
                            color: index % 2 == 0 ? Colors.black : Colors.grey,
                            fontWeight: FontWeight.w800,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Custom painter for dashed line decoration
class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
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
