package com.astrowaydiploy.user

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.annotation.RequiresApi
class ForegroundService : Service() {

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onCreate() {
        super.onCreate()
    Log.e("TAG", "ForegroundService init")
        val mapData = HashMap<String, String>().apply {
            put("id", Notifications.CHANNEL_ID)
            put("name", "Foreground Service")
            put("description", "Keeps app in foreground")
        }
        Log.e("TAG", "ForegroundService $mapData")

        Notifications.createSilentNotificationChannel(this, mapData)

        val notification = Notifications.buildForegroundNotification(this)
        startForeground(Notifications.NOTIFICATION_ID_BACKGROUND_SERVICE, notification)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.e("TAG", "START_STICKY")

        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        Log.e("TAG", "Stopping foreground service")
        stopForeground(true) // Remove the notification
        stopSelf() // St
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
