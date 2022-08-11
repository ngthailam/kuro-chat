extension StringExt on String {
  String getInitials() =>
      isNotEmpty ? trim().split(' ').map((l) => l[0]).take(2).join() : '';
}
