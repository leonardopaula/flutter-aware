package com.example.aware

import android.database.Cursor
import androidx.annotation.NonNull
import com.aware.Aware
import com.aware.Aware_Preferences
import com.aware.providers.Accelerometer_Provider
import com.aware.providers.Battery_Provider
import com.aware.providers.Locations_Provider
import com.aware.utils.DatabaseHelper
import com.aware.utils.Http
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*


class MainActivity: FlutterActivity() {
    private val CHANNEL = "leo/aware"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "accelerometer") {
                var ret = ""
                println(" ====> " + ret);
                val accelerometerData: Cursor? = contentResolver.query(Accelerometer_Provider.Accelerometer_Data.CONTENT_URI, null, null, null, Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (accelerometerData != null && accelerometerData.getCount() > 0) {

                    ret = DatabaseHelper.cursorToString(accelerometerData)
                    println(" ====> " + ret);
                } else {
                    println(" Nope");
                }
                if (accelerometerData != null && !accelerometerData.isClosed()) accelerometerData.close()

                result.success(ret)
            }
            if(call.method == "battery") {
                var ret = ""
                val batteryData: Cursor? = contentResolver.query(Battery_Provider.Battery_Data.CONTENT_URI, null, null, null, Battery_Provider.Battery_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (batteryData != null && batteryData.getCount() > 0) {

                    ret = DatabaseHelper.cursorToString(batteryData)
                } else {
                    println("Nope Bateria");
                }
                if (batteryData != null && !batteryData.isClosed()) batteryData.close()

                result.success(ret)
            }
            if(call.method == "location") {
                var ret = ""
                val locationData: Cursor? = contentResolver.query(Locations_Provider.Locations_Data.CONTENT_URI, null, null, null, Locations_Provider.Locations_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (locationData != null && locationData.getCount() > 0) {

                    ret = DatabaseHelper.cursorToString(locationData)
                }
                if (locationData != null && !locationData.isClosed()) locationData.close()

                result.success(ret)
            }
            if(call.method == "init"){
                Aware.startAWARE(applicationContext) //initialise core AWARE service
                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_ACCELEROMETER, true)
                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_BATTERY, true)
                Aware.startAccelerometer(applicationContext)
                Aware.startBattery(applicationContext)
            }
        }
    }
}
