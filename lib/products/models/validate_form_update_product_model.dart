class ValidateFormUpdateProductModel {
  String? errorMessageTitle;
  String? errorMessagePrice;
  String? errorMessageDescription;

  ValidateFormUpdateProductModel({this.errorMessageTitle, this.errorMessagePrice, this.errorMessageDescription});

  ValidateFormUpdateProductModel.fromJson(Map<String, dynamic> json) {
    errorMessageTitle = json['errorMessageTitle'];
    errorMessagePrice = json['errorMessagePrice'];
    errorMessageDescription = json['errorMessageDescription'];
  }

  ValidateFormUpdateProductModel copyWith({
    String? errorMessageTitle,
    String? errorMessagePrice,
    String? errorMessageDescription,
  }) {
    return ValidateFormUpdateProductModel(
      errorMessageTitle: errorMessageTitle ?? this.errorMessageTitle,
      errorMessagePrice: errorMessagePrice ?? this.errorMessagePrice,
      errorMessageDescription: errorMessageDescription ?? this.errorMessageDescription,
    );
  }
}
