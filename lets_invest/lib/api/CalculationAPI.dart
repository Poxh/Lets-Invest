class CalculationAPI {
  static double calculateProfitLostInEUR(currentPrice, boughtPrice) {
    return (currentPrice - boughtPrice);
  }

  static double calculateProfitLostInPercentage(currentPrice, boughtPrice) {
    return calculateProfitLostInEUR(currentPrice, boughtPrice) /
        boughtPrice *
        100;
  }

  static bool hasMadeLost(currentPrice, boughtPrice) {
    return calculateProfitLostInEUR(currentPrice, boughtPrice)
        .toString()
        .contains("-");
  }
}
