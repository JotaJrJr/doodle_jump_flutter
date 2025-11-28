import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// Service for handling gyroscope/accelerometer input for tilt controls
class SensorService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _tiltValue = 0.0;
  double _sensitivity = 0.3; // Adjustable sensitivity (0.1 = low, 1.0 = high)
  
  /// Get the current tilt value (-1.0 to 1.0)
  /// Negative = tilt left, Positive = tilt right
  double get tiltValue => _tiltValue;
  
  /// Get current sensitivity
  double get sensitivity => _sensitivity;
  
  /// Set sensitivity (0.1 to 1.0)
  set sensitivity(double value) {
    _sensitivity = value.clamp(0.1, 1.0);
  }
  
  /// Check if sensors are available on the device
  Future<bool> isSensorAvailable() async {
    try {
      // Try to get one reading to check availability
      final event = await accelerometerEventStream().first.timeout(
        const Duration(milliseconds: 500),
      );
      return true; // If we got here, sensor is available
    } catch (e) {
      return false;
    }
  }
  
  /// Start listening to accelerometer events
  void startListening() {
    _accelerometerSubscription?.cancel();
    
    _accelerometerSubscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        // X-axis tilt (device tilted left/right)
        // Normalize and apply sensitivity
        // event.x ranges approximately -10 to 10
        _tiltValue = (event.x / 10.0) * _sensitivity;
        _tiltValue = _tiltValue.clamp(-1.0, 1.0);
      },
      onError: (error) {
        print('Accelerometer error: $error');
        _tiltValue = 0.0;
      },
    );
  }
  
  /// Stop listening to accelerometer events
  void stopListening() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _tiltValue = 0.0;
  }
  
  /// Reset tilt value to neutral
  void reset() {
    _tiltValue = 0.0;
  }
  
  /// Clean up resources
  void dispose() {
    stopListening();
  }
}
