package com.astrowaydiploy.user
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.app.NotificationManager
import android.app.NotificationChannel
import android.net.Uri
import android.media.AudioAttributes
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.hiennv.flutter_callkit_incoming.CallkitConstants
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL_NAME = "com.astrowaydiploy.user/channel_test"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NotificationEventManager.initialize(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).setMethodCallHandler {
            call, result ->
            Log.e("TAG", "channel name is ${call.method}")
            if (call.method == "mynotichannel"){
                Log.e("TAG", "argument start: ${call.arguments}")
                val argData = call.arguments as java.util.HashMap<String, String>
                val completed = createNotificationChannel(argData)
                Log.e("TAG", "completed: $completed")
                if (completed == true){
                    Log.e("TAG", "in true part")
                    result.success(completed)
                }
                else{
                    Log.e("TAG", "in false part")
                    result.error("Error Code", "Error Message", null)
                }
            }
            else {
                result.notImplemented()
            }
        }

    }

    private fun createNotificationChannel(mapData: HashMap<String,String>): Boolean {
        val completed: Boolean
        if (VERSION.SDK_INT >= VERSION_CODES.O) {
            // Create the NotificationChannel
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
            "app_sound"
            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel(id, name, importance)
            mChannel.description = descriptionText
            val soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://"+ applicationContext.packageName + "/raw/app_sound")
            val att = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
            mChannel.setSound(soundUri, att)
            // Register the channel with the system; you can't change the importance
            // or other notification behaviors after this
            val notificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
            completed = true
        }
        else{
            completed = false
        }
        return completed
    }


}

