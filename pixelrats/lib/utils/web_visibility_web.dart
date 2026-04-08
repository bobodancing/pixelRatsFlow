import 'package:web/web.dart' as web;
import 'dart:js_interop';

typedef VisibilityCallback = void Function(bool isHidden);

VisibilityCallback? _activeCallback;
JSFunction? _jsListener;

void addVisibilityListener(VisibilityCallback callback) {
  _activeCallback = callback;
  _jsListener = ((web.Event _) {
    _activeCallback?.call(web.document.hidden);
  }).toJS;
  web.document.addEventListener('visibilitychange', _jsListener);
}

void removeVisibilityListener() {
  if (_jsListener != null) {
    web.document.removeEventListener('visibilitychange', _jsListener);
    _jsListener = null;
  }
  _activeCallback = null;
}

void saveToLocalStorage(String key, String value) {
  web.window.localStorage.setItem(key, value);
}

String? readFromLocalStorage(String key) {
  return web.window.localStorage.getItem(key);
}

void removeFromLocalStorage(String key) {
  web.window.localStorage.removeItem(key);
}
