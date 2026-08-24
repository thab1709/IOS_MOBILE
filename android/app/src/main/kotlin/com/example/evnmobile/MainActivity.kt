package com.example.evnmobile

import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import com.tom_roush.pdfbox.android.PDFBoxResourceLoader
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.*
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import android.graphics.pdf.PdfRenderer
import android.os.ParcelFileDescriptor
import android.graphics.Color

class MainActivity: FlutterActivity() {
    private var root: File? = null
    private var pageImage: Bitmap? = null
    private lateinit var pdfMethodChannel: MethodChannel
    private lateinit var ssoMethodChannel: MethodChannel
    private lateinit var ssoWebMethodChannel: MethodChannel
    private lateinit var deepLinkMethodChannel: MethodChannel
    private val parts = arrayListOf<String>()
    private var ticket : String? = null

    override fun onStart() {
        super.onStart()
        PDFBoxResourceLoader.init(applicationContext)
        // Find the root of the external storage.
        root = applicationContext.cacheDir
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val deepLink = intent?.data?.toString()
        if (isQrReportDeepLink(deepLink)) {
            if (::deepLinkMethodChannel.isInitialized) {
                deepLinkMethodChannel.invokeMethod("deepLink", deepLink)
            }
            return
        }

        ssoMethodChannel.invokeMethod("ssoResult", deepLink)
        ssoWebMethodChannel.invokeMethod("ssoResult", deepLink)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        pdfMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.evn.pmis/pdf"
        )
        ssoMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.evn.pmis/sso"
        )

        ssoMethodChannel.setMethodCallHandler { call, result ->
            val initialLink = intent?.data?.toString()
            if (!isQrReportDeepLink(initialLink)) {
                ssoMethodChannel.invokeMethod("ssoResultFirst", initialLink)
            }
        }

        ssoWebMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.evn.pmis/ssoWeb"
        )

        deepLinkMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.evn.pmis/deepLink"
        )

        deepLinkMethodChannel.setMethodCallHandler { call, result ->
            if (call.method == "getInitialLink") {
                result.success(intent?.data?.toString())
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "map_direction"
        ).setMethodCallHandler { call, result ->

            try {
                val locations = call.arguments.toString().split(',')
                val intent = Intent(
                    Intent.ACTION_VIEW,
                    Uri.parse("http://maps.google.com/maps?saddr=${locations[0]},${locations[1]}&daddr=${locations[2]},${locations[3]}")
                )
                startActivity(intent)
                result.success(true)
            } catch (e: Exception) {
                result.success(false)
            }
        }

        pdfMethodChannel.setMethodCallHandler { call, _ ->
            GlobalScope.launch(Dispatchers.Main) {
             val listPart = withContext(Dispatchers.IO) {
                 renderFile(
                     call.arguments as String
                 )
             }

                pdfMethodChannel.invokeMethod("pdfResult", listPart.toString())
            }
        }
    }

    private fun renderFile(filePart : String) : List<String> {
        // Render the page and save it to an image file using Native PdfRenderer
        try {
            context.cacheDir.deleteRecursively()
            parts.clear()
            root = applicationContext.cacheDir
            
            val fd = ParcelFileDescriptor.open(File(filePart), ParcelFileDescriptor.MODE_READ_ONLY)
            val pdfRenderer = PdfRenderer(fd)
            val pageSize = pdfRenderer.pageCount
            
            for(index in 0 until pageSize) {
                val page = pdfRenderer.openPage(index)
                val bitmap = Bitmap.createBitmap(page.width * 2, page.height * 2, Bitmap.Config.ARGB_8888)
                bitmap.eraseColor(Color.WHITE)
                page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)
                
                val path: String = root!!.absolutePath + "/render${System.currentTimeMillis()}_$index.png"
                val renderFile = File(path)
                val fileOut = FileOutputStream(renderFile)
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, fileOut)
                fileOut.close()
                parts.add(path)
                page.close()
            }
            pdfRenderer.close()
            fd.close()
            
            return parts

        } catch (e: Exception) {
            Log.e("PdfRenderer", "Exception thrown while rendering file", e)
            return  arrayListOf()
        }
    }

    private fun isQrReportDeepLink(deepLink: String?): Boolean {
        return try {
            val uri = Uri.parse(deepLink ?: return false)
            uri.scheme == "com.evn.pmis" &&
                    uri.host == "open" &&
                    uri.getQueryParameter("formReportId")?.isNotBlank() == true
        } catch (e: Exception) {
            false
        }
    }
}
