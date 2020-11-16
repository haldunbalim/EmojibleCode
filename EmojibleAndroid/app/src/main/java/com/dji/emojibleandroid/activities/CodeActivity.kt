package com.dji.emojibleandroid.activities

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.provider.MediaStore.ACTION_IMAGE_CAPTURE
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_code.*
import kotlinx.android.synthetic.main.activity_code.processButton
import kotlinx.android.synthetic.main.activity_emojies.*
import kotlinx.android.synthetic.main.list_emojies.*
import java.io.File

private const val FILE_NAME = "photo.jpg"
private const val REQUEST_CODE = 42
private lateinit var photoFile: File

class CodeActivity : AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_code)

        processButton.setOnClickListener(){

            val message: String = editTextCode.text.toString()
            showToast(message)
            val intent = Intent(this, ResultActivity::class.java)
            intent.putExtra(Constants.USER_MSG_KEY, message)
            startActivity(intent)


        }

        cameraButton.setOnClickListener(){

            showToast("Camera!")
            val takePictureIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            photoFile = getPhotoFile(FILE_NAME)

            val fileProvider = FileProvider.getUriForFile(this,"com.dji.emojibleandroid.fileprovider", photoFile)
            takePictureIntent.putExtra(MediaStore.EXTRA_OUTPUT, fileProvider)
            if(takePictureIntent.resolveActivity(this.packageManager) != null){

                startActivityForResult(takePictureIntent, REQUEST_CODE)

            }else{

                showToast("Unable to open camera")

            }
        }

        shareImageView.setOnClickListener(){

            val message: String = editTextCode.text.toString()
            val intent = Intent()
            intent.action = Intent.ACTION_SEND
            intent.putExtra(Intent.EXTRA_TEXT, message)
            intent.type = "text/plain"
            startActivity(Intent.createChooser(intent,"Share with: "))

        }

    }

    private fun getPhotoFile(fileName: String): File {
        val storageDir = getExternalFilesDir(Environment.DIRECTORY_PICTURES)
        return File.createTempFile(fileName,".jpg",storageDir)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {

        if(requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK){

            val takenImage = BitmapFactory.decodeFile(photoFile.absolutePath)
            cameraImageView.setImageBitmap(takenImage)

        }else{

            super.onActivityResult(requestCode, resultCode, data)

        }
    }

}