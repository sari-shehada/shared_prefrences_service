enum SharedPrefsOperationMode {
  read,
  write,
  clearValue,
  clearAll;

  String get operationModeAsString {
    switch (this) {
      case SharedPrefsOperationMode.read:
        {
          return 'Read-Mode';
        }
      case SharedPrefsOperationMode.write:
        {
          return 'Write-Mode';
        }
      case SharedPrefsOperationMode.clearValue:
        {
          return 'Clear-Value-Mode';
        }
      case SharedPrefsOperationMode.clearAll:
        {
          return 'Clear-All-Mode';
        }
    }
  }
}
