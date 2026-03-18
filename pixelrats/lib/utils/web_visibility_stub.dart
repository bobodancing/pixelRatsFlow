/// Stub for non-web platforms — no-ops.
typedef VisibilityCallback = void Function(bool isHidden);

void addVisibilityListener(VisibilityCallback callback) {}

void removeVisibilityListener() {}

void saveToLocalStorage(String key, String value) {}

String? readFromLocalStorage(String key) => null;

void removeFromLocalStorage(String key) {}
