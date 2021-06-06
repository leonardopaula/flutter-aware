package com.example.aware

import android.database.Cursor
import androidx.annotation.NonNull
import com.aware.Aware
import com.aware.Aware_Preferences
import com.aware.providers.*
import com.aware.utils.DatabaseHelper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "ch/aware"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            if (call.method == "init") {

                Aware.stopAWARE(applicationContext)
                Aware.setSetting(applicationContext, Aware_Preferences.DEVICE_ID, call.argument("uuid"))

                Aware.startAWARE(applicationContext) // Start Aware Service

                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_ACCELEROMETER, true)
                Aware.setSetting(applicationContext, Aware_Preferences.FREQUENCY_ACCELEROMETER, 200000 )
                Aware.startAccelerometer(applicationContext)

                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_BATTERY, true)
                Aware.startBattery(applicationContext)

                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_LOCATION_GPS, true)
                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_LOCATION_NETWORK, true)
                Aware.startLocations(applicationContext)

                Aware.setSetting(applicationContext, Aware_Preferences.STATUS_LIGHT, true)
                Aware.startLight(applicationContext)
            }

            if (call.method == "accelerometer") {
                var ret = ""
                val accelerometerData: Cursor? = contentResolver.query(
                    Accelerometer_Provider.Accelerometer_Data.CONTENT_URI,
                    null,
                    null,
                    null,
                    Accelerometer_Provider.Accelerometer_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (accelerometerData != null && accelerometerData.getCount() > 0) {
                    ret = DatabaseHelper.cursorToString(accelerometerData)
                }
                if (accelerometerData != null && !accelerometerData.isClosed()) accelerometerData.close()
                contentResolver.delete(Accelerometer_Provider.Accelerometer_Data.CONTENT_URI, null, null)
                result.success(ret)
            }

            if (call.method == "battery") {
                var ret = ""
                val batteryData: Cursor? = contentResolver.query(Battery_Provider.Battery_Data.CONTENT_URI, null, null, null, Battery_Provider.Battery_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (batteryData != null && batteryData.getCount() > 0) {
                    ret = DatabaseHelper.cursorToString(batteryData)
                }
                if (batteryData != null && !batteryData.isClosed()) batteryData.close()
                contentResolver.delete(Battery_Provider.Battery_Data.CONTENT_URI, null, null)
                result.success(ret)
            }

            if (call.method == "location") {
                var ret = ""
                val locationData: Cursor? = contentResolver.query(Locations_Provider.Locations_Data.CONTENT_URI, null, null, null, Locations_Provider.Locations_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (locationData != null && locationData.getCount() > 0) {
                    ret = DatabaseHelper.cursorToString(locationData)
                }
                if (locationData != null && !locationData.isClosed()) locationData.close()
                contentResolver.delete(Locations_Provider.Locations_Data.CONTENT_URI, null, null)
                result.success(ret)
            }

            if (call.method == "light") {
                var ret = ""
                val lightData: Cursor? = contentResolver.query(
                    Light_Provider.Light_Data.CONTENT_URI, null, null, null,
                    Light_Provider.Light_Data.TIMESTAMP + " DESC LIMIT 1000")
                if (lightData != null && lightData.getCount() > 0) {
                    ret = DatabaseHelper.cursorToString(lightData)
                }
                if (lightData != null && !lightData.isClosed()) lightData.close()
                contentResolver.delete(Light_Provider.Light_Data.CONTENT_URI, null, null)
                result.success(ret)
            }
        }
    }
}