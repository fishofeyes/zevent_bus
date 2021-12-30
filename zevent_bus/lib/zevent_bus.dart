// ignore_for_file: prefer_generic_function_type_aliases

library zevent_bus;

typedef void EventCallback(arg);

class EventBus {
  factory EventBus() => _getInstance();
  static EventBus get instance => _getInstance();
  static EventBus? _instance;

  EventBus._internal() {
    // init
  }
  static EventBus _getInstance() {
    _instance ??= EventBus._internal();
    return _instance!;
  }

  final Map<String, List<EventCallback>?> _events = {};

  /// 添加监听
  void addListener({String? eventKey, EventCallback? callback}) {
    if (eventKey == null || callback == null) return;
    if (_events[eventKey] != null) {
      _events[eventKey] = [..._events[eventKey]!, callback];
    } else {
      _events[eventKey] = [callback];
    }
  }

  /// 移除监听
  void removeListener(String? eventKey) {
    if (eventKey == null) return;
    if (_events[eventKey]?.isNotEmpty == true) {
      List<EventCallback> list = _events[eventKey]!;
      list.removeLast();
      _events[eventKey] = [...list];
    }
  }

  /// 发送事件
  void commit({String? eventKey, Object? arg}) {
    if (eventKey == null) return;
    List<EventCallback>? callbacks = _events[eventKey];
    if (callbacks != null) {
      for (var element in callbacks) {
        element(arg);
      }
    }
  }
}
