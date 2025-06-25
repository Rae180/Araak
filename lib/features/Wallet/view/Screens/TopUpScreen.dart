import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:start/features/Wallet/Bloc/Wallet_bloc/wallet_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopUpScreen extends StatefulWidget {
  static const String routeName = '/TopUp_screen';
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  final CardFormEditController _cardFormController = CardFormEditController();

  @override
  void initState() {
    super.initState();

    EasyLoading.instance
      ..displayDuration = const Duration(seconds: 3)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle;
  }

  Future<void> _handlePayment(BuildContext context) async {
    final amount = int.tryParse(_amountController.text) ?? 0;
    if (amount < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount must be at least 1 cent')),
      );
      return;
    }
    final details = _cardFormController.details;
    if (details == null || !details.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete card details')),
      );
      return;
    }
    try {
      EasyLoading.show(status: 'Processing...');
      final token = await Stripe.instance.createToken(
        const CreateTokenParams.card(
          params: CardTokenParams(
              type: TokenType.Card,
              currency: 'usd',
              name: 'Card Holder',
              address: Address(
                  city: 'Tartous',
                  country: 'USA',
                  line1: 'Line1',
                  line2: 'Line2',
                  postalCode: '00000',
                  state: 'mechigan')),
        ),
      );
      context.read<WalletBloc>().add(
            TopUpWalletEvent(
              token: token.id,
              amount: amount,
              descriptione: 'Wallet top-up',
              payment_method: 'card',
              currency: 'usd',
            ),
          );
      EasyLoading.dismiss();
      Navigator.pop(context);
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _cardFormController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(client: NetworkApiServiceHttp()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top-Up Wallet',
              style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (in cents)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CardFormField(
                dangerouslyGetFullCardDetails: true,
                controller: _cardFormController,
                style: CardFormStyle(
                  backgroundColor: Colors.grey[200],
                  borderColor: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Builder(
                builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      final amount = int.tryParse(_amountController.text) ?? 0;
                      if (amount < 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Amount must be at least 1 cent')),
                        );
                        return;
                      }
                      final details = _cardFormController.details;
                      if (details == null || !details.complete) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please complete card details')),
                        );
                        return;
                      }
                      try {
                        EasyLoading.show(status: 'Processing...');
                        final token = await Stripe.instance.createToken(
                          const CreateTokenParams.card(
                            params: CardTokenParams(
                  type: TokenType.Card,
                  currency: 'usd',
                  name: 'Card Holder',
                  address: Address(
                      city: 'Tartous',
                      country: 'USA',
                      line1: 'Line1',
                      line2: 'Line2',
                      postalCode: '00000',
                      state: 'mechigan')),
                          ),
                        );
                        context.read<WalletBloc>().add(
                              TopUpWalletEvent(
                  token: token.id,
                  amount: amount,
                  descriptione: 'Wallet top-up',
                  payment_method: 'card',
                  currency: 'usd',
                              ),
                            );
                        EasyLoading.dismiss();
                        Navigator.pop(context);
                      } catch (e) {
                        EasyLoading.dismiss();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                    child: const Text('Confirm Payment'),
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
