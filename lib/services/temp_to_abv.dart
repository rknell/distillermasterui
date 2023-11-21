import 'dart:math';

class TempToABV {
  static final List<double> abv = [
    0,
    2.483,
    5.464,
    10.099,
    10.43,
    13.907,
    20.033,
    25.993,
    30.795,
    35.762,
    40.232,
    44.868,
    52.483,
    54.967,
    59.768,
    64.735,
    69.868,
    71.026,
    76.159,
    78.642,
    80.96,
    85.762,
    86.755,
    89.735,
    92.715,
    94.702,
    100
  ];

  static final List<double> liquidTemp = [
    99.9373,
    98.0543,
    95.7947,
    93.0317,
    92.8417,
    91.0217,
    88.5702,
    86.8082,
    85.5489,
    84.4774,
    83.7853,
    83.15,
    82.2632,
    82.0018,
    81.5021,
    80.9804,
    80.4242,
    80.2942,
    79.7002,
    79.4106,
    79.1455,
    78.6236,
    78.5231,
    78.2582,
    78.077,
    77.9926,
    77.8172
  ];

  static final List<double> vaporTemp = [
    100.04,
    99.7712,
    99.4513,
    98.9569,
    98.9217,
    98.5512,
    97.8932,
    97.2378,
    96.6896,
    96.0898,
    95.5005,
    94.796,
    93.2741,
    92.6622,
    91.4,
    89.8301,
    87.4715,
    86.877,
    84.4267,
    83.0684,
    81.7889,
    79.6523,
    79.3261,
    78.6447,
    78.1696,
    77.9492,
    77.7546
  ];

  static double interpolate(
      double temperature, List<double> xValues, List<double> yValues) {
    if (temperature <= xValues.first) {
      return yValues.first;
    }
    if (temperature >= xValues.last) {
      return yValues.last;
    }

    int index = 0;
    while (temperature > xValues[index]) {
      index++;
    }

    double x0 = xValues[index - 1];
    double x1 = xValues[index];
    double y0 = yValues[index - 1];
    double y1 = yValues[index];

    return y0 + (temperature - x0) * (y1 - y0) / (x1 - x0);
  }

  static double getLiquidABV(double temperature) {
    return interpolate(temperature, liquidTemp, abv);
  }

  static double getVaporABV(double temperature) {
    return interpolate(temperature, vaporTemp, abv);
  }
}
