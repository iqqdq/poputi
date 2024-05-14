extension DateTimeVerification on DateTime {
  bool isActual() {
    DateTime now = DateTime.now().toLocal();

    return year == now.year && month == now.month && day >= now.day;
  }
}
