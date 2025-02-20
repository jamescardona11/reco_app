enum AudioRecorderState {
  idle,
  recording,
  error,
  stopped;

  bool get isIdle => this == idle;
  bool get isRecording => this == recording;
  bool get isError => this == error;
  bool get isStopped => this == stopped;
}
