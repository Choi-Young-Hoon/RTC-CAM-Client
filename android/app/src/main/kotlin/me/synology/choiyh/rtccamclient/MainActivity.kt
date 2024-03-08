package me.synology.choiyh.rtccamclient
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.AlertDialog

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.choiyh.pip"
    private var isUsePIPMode: Boolean = false;

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method.equals("enterPIPMode")) {
                enterPictureInPictureMode()
                result.success(null)
            } else if (call.method.equals("setPIPMode")) {
                isUsePIPMode = call.arguments<Boolean>() ?: false
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode)
        if (!isInPictureInPictureMode) {
            // 전체 화면 모드로 돌아왔을 때 sendPiPModeMessage(false) 호출
            sendPiPModeMessage(false)
        }
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        runPIPMode(true)
    }

    override fun onBackPressed() {
        AlertDialog.Builder(this)
            .setTitle("종료 확인")
            .setMessage("정말로 종료하시겠습니까?")
            .setPositiveButton("예") { _, _ ->
                super.onBackPressed()
            }
            .setNegativeButton("아니오") { _, _ ->
                runPIPMode(true)
            }
            .show()
    }

    private fun sendPiPModeMessage(isInPiPMode: Boolean) {
        flutterEngine?.let { engine ->
            engine.dartExecutor.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("pipModeChanged", isInPiPMode)
            }
        }
    }

    private fun runPIPMode(isInPiPMode: Boolean) {
        if (isUsePIPMode) {
            enterPictureInPictureMode()
            sendPiPModeMessage(isInPiPMode)
        }
    }
}