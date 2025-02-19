enum AudioRecorderState {
  recording,
  stopped,
  paused,
  playing;

  bool get isRecording => this == recording;
  bool get isStopped => this == stopped;
  bool get isPaused => this == paused;
  bool get isPlaying => this == playing;
}
