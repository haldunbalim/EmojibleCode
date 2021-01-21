package com.dji.emojibleandroid.activities

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.widget.EditText
import androidx.core.content.FileProvider
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.ProgramsAdapter
import com.dji.emojibleandroid.dataSources.ProgramDataSource
import com.dji.emojibleandroid.extensions.AppCompatActivityWithAlerts
import com.dji.emojibleandroid.extensions.hideProgressBar
import com.dji.emojibleandroid.extensions.showProgressBar
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.ProgramModel
import com.dji.emojibleandroid.services.VisionModelApi
import com.dji.emojibleandroid.services.VisionModelResponse
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.EmojiUtils.programs
import com.dji.emojibleandroid.utils.URIPathHelper
import com.dji.emojibleandroid.utils.setupToolbar
import com.google.gson.Gson
import kotlinx.android.synthetic.main.activity_program.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.RequestBody.Companion.asRequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.io.File


private const val FILE_NAME = "photo.jpg"
private const val REQUEST_CODE = 42
private lateinit var photoFile: File


class ProgramActivity : AppCompatActivityWithAlerts() {

    internal companion object {
        //image pick code
        private val IMAGE_PICK_CODE = 1000;

        //Permission code
        private val PERMISSION_CODE = 1001;

        const val BASE_URL = "http://ec2-18-197-151-213.eu-central-1.compute.amazonaws.com:8000"
    }

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_program)
        val type = intent.getStringExtra("type")
        val titleEditText: EditText = findViewById(R.id.titleEditText)
        if (type == "editProgram") {
            titleEditText.setText(intent.getStringExtra("title"))
            codeEditText.setText(intent.getStringExtra("code"))
        } else {
            deleteCodeButton.text = "Return"
        }

        cameraImageView.setOnClickListener {
            val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            photoFile = getPhotoFile(FILE_NAME)

            val fileProvider =
                FileProvider.getUriForFile(this, "com.dji.emojibleandroid.fileprovider", photoFile)
            takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, fileProvider)
            if (takePictureIntent.resolveActivity(this.packageManager) != null) {

                startActivityForResult(takePictureIntent, REQUEST_CODE)

            } else {

                showToast("Unable to open camera")

            }

        }

        galleryImageView.setOnClickListener {

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) ==
                    PackageManager.PERMISSION_DENIED
                ) {
                    //permission denied
                    val permissions = arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE);
                    //show popup to request runtime permission
                    requestPermissions(permissions, PERMISSION_CODE);
                } else {
                    //permission already granted
                    pickImageFromGallery();
                }
            } else {
                //system OS is < Marshmallow
                pickImageFromGallery();
            }

        }

        saveCodeButton.setOnClickListener {
            val codeTitle = titleEditText.text.toString()
            val newCodeModel = CodeModel(codeTitle, codeEditText.text.toString())
            val newProgramModel = ProgramModel(ProgramsAdapter.VIEW_TYPE_TWO, newCodeModel)
            if (type == "editProgram") {
                val oldIndex = intent.getIntExtra("position", -1)
                ProgramDataSource.instance.editProgram(
                    programs[oldIndex] as CodeModel,
                    newCodeModel
                )
                programs[oldIndex] = newProgramModel
            } else {
                val same = programs.find { it.name == codeTitle }
                if (same != null) {
                    programs[programs.indexOf(same)] = newProgramModel
                    ProgramDataSource.instance.editProgram(same as CodeModel, newCodeModel)
                } else {
                    programs.add(newProgramModel)
                    ProgramDataSource.instance.writeProgram(newCodeModel)
                }
            }
            val intent = Intent(this, GridProgramActivity::class.java)
            startActivity(intent)
            finish()
        }

        deleteCodeButton.setOnClickListener {
            if (type == "editProgram") {
                val idx = intent.getIntExtra("position", -1)
                val oldProgramModel = programs[idx]
                ProgramDataSource.instance.removeProgram(oldProgramModel as CodeModel)
                programs.removeAt(idx)
            }
            val intent = Intent(this, GridProgramActivity::class.java)
            startActivity(intent)
            finish()
        }

        setupToolbar(
            this,
            programLayoutToolbar,
            tutorialLayoutToolbar,
            emojiLayoutToolbar,
            userLayoutToolbar
        )
    }


    private fun getPhotoFile(fileName: String): File {
        val storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile(fileName, ".jpg", storageDir)
    }

    private fun pickImageFromGallery() {
        //Intent to pick image
        val intent = Intent(Intent.ACTION_PICK)
        intent.type = "image/*"
        startActivityForResult(intent, IMAGE_PICK_CODE)

    }

    //handle requested permission result
    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        when (requestCode) {
            PERMISSION_CODE -> {
                if (grantResults.size > 0 && grantResults[0] ==
                    PackageManager.PERMISSION_GRANTED
                ) {
                    //permission from popup granted
                    pickImageFromGallery()
                } else {
                    //permission from popup denied
                    showToast("Permission denied")
                }
            }
        }
    }

    //handle result of picked image
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (resultCode == Activity.RESULT_OK && requestCode == IMAGE_PICK_CODE) {
            showProgressBar()
            GlobalScope.launch { requestImageResult(data) }

        } else if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {

            val takenImage = BitmapFactory.decodeFile(photoFile.absolutePath)
            TODO("Çektiğin fotoyu aldın")

        } else {

            super.onActivityResult(requestCode, resultCode, data)

        }
    }

    fun requestImageResult(data: Intent?) {
        val httpClient = OkHttpClient.Builder()
        val retrofit = Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create(Gson()))
            .client(httpClient.build())
            .build()

        val service = retrofit.create(VisionModelApi::class.java)
        val filepath = data?.data?.let { URIPathHelper().getPath(this, it) }

        val file = File(filepath!!)

        val requestFile = file.asRequestBody("multipart/form-data".toMediaTypeOrNull())

        val body = MultipartBody.Part.createFormData("file", file.name, requestFile)

        val call = service.getCodeFromImage(body)
        call.enqueue(object : Callback<VisionModelResponse> {
            override fun onResponse(
                call: Call<VisionModelResponse>,
                response: Response<VisionModelResponse>
            ) {
                hideProgressBar()
                codeEditText.setText(response.body()?.code)
            }

            override fun onFailure(call: Call<VisionModelResponse>, t: Throwable) {
                hideProgressBar()
                showToast("Call to API failed due to ${t.message}")
            }

        })
    }
}