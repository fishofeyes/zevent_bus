// ignore_for_file: always_specify_types

typedef EventCallback = void Function(dynamic arg);
typedef EventRemoveCallback = void Function();

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

  final Map<String, List<EventCallback>?> _events = <String, List<EventCallback>?>{};

  /// 添加监听
  EventRemoveCallback? addListener({String? eventKey, EventCallback? callback}) {
    if (eventKey == null || callback == null) return null;
    if (_events[eventKey] != null) {
      _events[eventKey] = [..._events[eventKey]!, callback];
    } else {
      _events[eventKey] = [callback];
    }
    return () {
      _removeListener(eventKey, callback);
    };
  }

  /// 移除监听
  void _removeListener(String? eventKey, EventCallback? callback) {
    if (eventKey == null) return;
    if (_events[eventKey]?.isNotEmpty == true) {
      final List<EventCallback> list = _events[eventKey]!;
      if (callback == null) {
        list.removeLast();
      } else {
        list.remove(callback);
      }
      if (list.isEmpty) {
        _events.remove(eventKey);
      } else {
        _events[eventKey] = [...list];
      }
    }
  }

  /// 发送事件
  void commit({String? eventKey, Object? arg}) {
    if (eventKey == null) return;
    final List<EventCallback>? callbacks = _events[eventKey];
    if (callbacks != null) {
      for (var element in callbacks) {
        element(arg);
      }
    }
  }
}
