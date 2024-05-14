extension DateTimeVerification on DateTime {
  bool isPast() {
    DateTime local = toLocal();
    DateTime dateTime = DateTime(local.year, local.month, local.day, 0, 0, 0);

    DateTime localNow = DateTime.now().toLocal();
    DateTime now =
        DateTime(localNow.year, localNow.month, localNow.day, 0, 0, 0);

    return dateTime.isBefore(now);
  }
}
