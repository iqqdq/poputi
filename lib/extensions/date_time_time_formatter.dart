extension DateTimeTimeFormatter on DateTime {
  String toTime() {
    var hour = this.hour.toString().length > 1 ? this.hour : '0${this.hour}';
    var minute =
        this.minute.toString().length > 1 ? this.minute : '0${this.minute}';

    return '$hour:$minute';
  }
}
