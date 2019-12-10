class PresentData {
  // 工厂模式
  var index=0;
  factory PresentData() => _getInstance();
  static PresentData get instance => _getInstance();
  static PresentData _instance;
  PresentData._internal() {
    // 初始化
  }
  static PresentData _getInstance() {
    if (_instance == null) {
      _instance = new PresentData._internal();
    }
    return _instance;
  }
}
