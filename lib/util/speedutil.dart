class SpeedUtil {
  static const double nan = 0.0 / 0.0;
  static getSpeedFormat(var downloadSpeed) {
    double d = int.parse(downloadSpeed) / 1024;
    if (d < 1) {
      return downloadSpeed + "b/s";
    } else {
      double m = d / 1024;
      if (m < 1) {
        return d.toStringAsFixed(2) + "kb/s";
      } else {
        return m.toStringAsFixed(2) + "mb/s";
      }
    }
  }
}
