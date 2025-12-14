/// Simple debounce utility for async & UI events.
class Debouncer {
  Debouncer({this.milliseconds = 400});


  final int milliseconds;
  void Function()? _action;


  void run(void Function() action) {
    _action?.call();
    _action = action;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      if (_action == action) action();
    });
  }
}