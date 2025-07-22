import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/core/managers/theme_manager.dart';
import 'package:start/features/Wallet/Bloc/Wallet_bloc/wallet_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopUpScreen extends StatefulWidget {
  static const String routeName = '/TopUp_screen';
  const TopUpScreen({Key? key}) : super(key: key);

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final CardFormEditController _cardFormController = CardFormEditController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _configureEasyLoading();
  }

  void _configureEasyLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(seconds: 3)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..maskType = EasyLoadingMaskType.custom
      ..maskColor = Colors.black.withOpacity(0.4)
      ..backgroundColor = Colors.black.withOpacity(0.7)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white;
  }

  Future<void> _handlePayment(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_cardFormController.details.complete) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.completedcard)),
      );
      return;
    }

    setState(() => _isProcessing = true);
    EasyLoading.show(status: AppLocalizations.of(context)!.processing);

    try {
      final token = await Stripe.instance.createToken(
        CreateTokenParams.card(
          params: CardTokenParams(
            type: TokenType.Card,
            currency: 'usd',
            name: 'Card Holder',
            address: Address(
              city: 'City',
              country: 'Country',
              line1: 'Adress line 1',
              line2: 'Adress line 2',
              postalCode: 'postalcode',
              state: 'State',
            ),
          ),
        ),
      );

      final amount = int.tryParse(_amountController.text) ?? 0;
      context.read<WalletBloc>().add(
            TopUpWalletEvent(
              token: token.id,
              amount: amount,
              descriptione: 'Top-Up wallet',
              payment_method: 'card',
              currency: 'usd',
            ),
          );
    } catch (e) {
      EasyLoading.dismiss();
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'Error'}: $e')),
      );
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkMode = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => WalletBloc(client: NetworkApiServiceHttp()),
      child: BlocListener<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is TopUpWalletSuccess) {
            EasyLoading.showSuccess(l10n.topupsuccess);
            setState(() => _isProcessing = false);
            Navigator.pop(context);
          } else if (state is WalletErrorState) {
            EasyLoading.dismiss();
            setState(() => _isProcessing = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              l10n.topupwallet,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
            elevation: 0,
            centerTitle: true,
            scrolledUnderElevation: 0,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.sectionPadding),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    l10n.addfunds,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'l10n.topupdesc',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Amount input
                  Text(
                    l10n.amount,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      hintText: l10n.amountcents,
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius),
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? colorScheme.surfaceVariant
                          : colorScheme.background,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enteramount;
                      }
                      final amount = int.tryParse(value) ?? 0;
                      if (amount < 100) {
                        return 'l10n.minamount';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Card details
                  Text(
                    'l10n.carddetails',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                      color: isDarkMode
                          ? colorScheme.surfaceVariant
                          : colorScheme.background,
                      border: Border.all(
                        color: colorScheme.outline.withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: CardFormField(
                      dangerouslyGetFullCardDetails: true,
                      controller: _cardFormController,
                      style: CardFormStyle(
                        backgroundColor: isDarkMode
                            ? colorScheme.surfaceVariant
                            : colorScheme.background,
                        textColor: colorScheme.onSurface,
                        placeholderColor:
                            colorScheme.onSurface.withOpacity(0.5),
                        borderColor: colorScheme.outline,
                        borderRadius: AppConstants.cardRadius.toInt(),
                        cursorColor: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Payment button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isProcessing ? null : () => _handlePayment(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.cardRadius),
                        ),
                        elevation: 2,
                      ),
                      child: _isProcessing
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.confirmpay,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info text
                  Text(
                    l10n.paymentsecure,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size: 14, color: colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        l10n.securedstripe,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
