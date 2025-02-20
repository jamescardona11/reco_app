enum UploadingState {
  uploading,
  error,
  completed;

  bool get isUploading => this == UploadingState.uploading;
  bool get isError => this == UploadingState.error;
  bool get isCompleted => this == UploadingState.completed;
}
