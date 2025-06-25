// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lacalization_cubit.dart';

class LacalizationState extends Equatable {
  final Locale locale;
  final bool isLoading;
  const LacalizationState({
    required this.locale,
    this.isLoading = false,
  });

  LacalizationState copyWith({
    Locale? locale,
    bool? isLoading,
  }) {
    return LacalizationState(
      locale: locale ?? this.locale,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [locale];
}
