import 'package:semesta/public/extensions/string_extension.dart';
import 'package:semesta/public/functions/custom_toast.dart';
import 'package:semesta/public/utils/type_def.dart';
import 'package:sn_progress_dialog/options/completed.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class MediaSaving {
  final ProgressDialog pd;
  MediaSaving(this.pd);

  AsWait download(String path) {
    _safeShow();

    return path.toDownload(_onProgress);
  }

  bool _isShowing = false;
  void _safeShow() {
    if (_isShowing) return;
    _isShowing = true;

    pd.show(
      msg: 'Downloading...',
      completed: Completed(
        completedMsg: 'Downloading Done !',
        completionDelay: 2500,
      ),
    );
  }

  int _lastProgress = 0;
  void _onProgress(int received, int total) {
    final progress = ((received / total) * 100).toInt();

    if (progress - _lastProgress >= 2) {
      _lastProgress = progress;
      pd.update(value: progress, msg: 'Downloading... $progress%');
    }

    if (progress >= 100) _safeClose();
  }

  void _safeClose() {
    if (!_isShowing) return;
    _isShowing = false;

    pd.close();
    CustomToast.info('Saved to gallery');
  }
}
