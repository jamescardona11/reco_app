enum AudioRecorderState {
  idle,
  recording,
  stopped;

  bool get isIdle => this == idle;
  bool get isRecording => this == recording;
  bool get isStopped => this == stopped;
}
