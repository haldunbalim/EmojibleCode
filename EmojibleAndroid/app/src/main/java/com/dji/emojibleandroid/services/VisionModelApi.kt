package com.dji.emojibleandroid.services

import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Response
import retrofit2.http.Multipart
import retrofit2.http.POST
import retrofit2.http.Part

interface VisionModelApi {

    @Multipart
    @POST("/file/upload/")
    fun getCodeFromImage(@Part file: MultipartBody.Part): Call<VisionModelResponse>
}