package com.example.mvp_govarzea

import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import okhttp3.*
import org.json.JSONObject
import java.io.IOException
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.RequestBody.Companion.toRequestBody

class MyFirebaseService : FirebaseMessagingService() {

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d("FCM", "Novo token: $token")
        // Envia o token para o servidor
        sendTokenToServer(token)
    }

    private fun sendTokenToServer(token: String) {
        val url = "http://10.0.2.2:8080/register-token" // se usar emulador Android

        val json = JSONObject()
        json.put("token", token)

        val requestBody = json.toString().toRequestBody("application/json".toMediaTypeOrNull())

        val request = Request.Builder()
            .url(url)
            .post(requestBody)
            .build()

        val client = OkHttpClient()
        client.newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                Log.e("FCM", "Erro ao enviar token: ${e.message}")
            }

            override fun onResponse(call: Call, response: Response) {
                Log.d("FCM", "Token enviado com sucesso: ${response.code}")
            }
        })
    }
}
