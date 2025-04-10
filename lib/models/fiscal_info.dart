//enum FiscalStatus { particulier, entreprise }

class FiscalInfo {
  final String? paymentMethod;
  final String? paymentPhoneNumberController;
  final String? payementOwnerNameController;
  final String? storeFiscalType;

  FiscalInfo({
    this.paymentMethod,
    this.paymentPhoneNumberController,
    this.payementOwnerNameController,
    this.storeFiscalType = 'Particulier',
  });

  FiscalInfo copyWith({
    String? paymentMethod,
    String? paymentPhoneNumberController,
    String? payementOwnerNameController,
    String? storeFiscalType,
  }) {
    return FiscalInfo(
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentPhoneNumberController:
          paymentPhoneNumberController ?? this.paymentPhoneNumberController,
      payementOwnerNameController:
          payementOwnerNameController ?? this.payementOwnerNameController,
      storeFiscalType: storeFiscalType ?? this.storeFiscalType,
    );
  }
}
