import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.os.IBinder
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import com.astrowaydiploy.user.R

object Notifications {
    const val CHANNEL_ID = "foreground_channel"
    const val NOTIFICATION_ID_BACKGROUND_SERVICE = 1111

    @RequiresApi(Build.VERSION_CODES.O)
    fun createNotificationChannel(context: Context, mapData: HashMap<String,String>): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
            val importance = NotificationManager.IMPORTANCE_HIGH
            val mChannel = NotificationChannel(id, name, importance).apply {
                description = descriptionText
                val soundUri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE + "://" + context.packageName + "/raw/app_sound")
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                    .build()
                setSound(soundUri, audioAttributes)
            }
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
            return true
        }
        return false
    }

    @RequiresApi(Build.VERSION_CODES.O)
    fun createSilentNotificationChannel(context: Context, mapData: HashMap<String,String>): Boolean {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val id = mapData["id"]
            val name = mapData["name"]
            val descriptionText = mapData["description"]
            val importance = NotificationManager.IMPORTANCE_LOW // Lower importance, so it's silent
            val mChannel = NotificationChannel(id, name, importance).apply {
                description = descriptionText
                setSound(null, null) // No sound
                enableVibration(false) // Disable vibration
                enableLights(false) // Disable lights if you want
            }
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(mChannel)
            return true
        }
        return false
    }


    fun buildForegroundNotification(context: Context): Notification {
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Background Service")
            .setContentText("Keeps app process on foreground.")
            .build()
    }
}

