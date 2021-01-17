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
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.FileProvider
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.adapters.ProgramsAdapter
import com.dji.emojibleandroid.dataSources.ProgramDataSource
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.ProgramModel
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.EmojiUtils.programs
import kotlinx.android.synthetic.main.activity_program.*
import kotlinx.android.synthetic.main.activity_program.emojiLayoutToolbar
import kotlinx.android.synthetic.main.activity_program.programLayoutToolbar
import kotlinx.android.synthetic.main.activity_program.tutorialLayoutToolbar
import kotlinx.android.synthetic.main.activity_program.userLayoutToolbar
import java.io.File


private const val FILE_NAME = "photo.jpg"
private const val REQUEST_CODE = 42
private lateinit var photoFile: File


class ProgramActivity : AppCompatActivity() {

    internal companion object {
        //image pick code
        private val IMAGE_PICK_CODE = 1000;

        //Permission code
        private val PERMISSION_CODE = 1001;
    }

    override fun onCreate(savedInstanceState: Bundle?) {

        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_program)
        val type = intent.getStringExtra("type")
        val titleEditText: EditText = findViewById(R.id.titleEditText)
        if (type == "editProgram") {
            titleEditText.setText(intent.getStringExtra("title"))
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

        processButton.setOnClickListener {

            val codeEditText: EditText = findViewById(R.id.codeEditText)
            var sameExists = false
            for (program in programs) {

                if (program.name == titleEditText.text.toString()) {
                    ProgramDataSource.instance.editProgram(
                        program as CodeModel,
                        CodeModel(program.name, codeEditText.text.toString())
                    )
                    program.code = codeEditText.text.toString()
                    sameExists = true
                }
            }
            if (!sameExists) {
                val codeModel =
                    CodeModel(titleEditText.text.toString(), codeEditText.text.toString())
                ProgramDataSource.instance.writeProgram(codeModel)
                val programModel = ProgramModel(ProgramsAdapter.VIEW_TYPE_TWO, codeModel)
                programs.add(
                    programs.size,
                    programModel
                )
            }
            val intent = Intent(this, GridProgramActivity::class.java)
            startActivity(intent)
        }

        com.dji.emojibleandroid.utils.setupToolbar(
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

            TODO("Galeriden foto alınıyor burda işle")

        } else if (requestCode == REQUEST_CODE && resultCode == Activity.RESULT_OK) {

            val takenImage = BitmapFactory.decodeFile(photoFile.absolutePath)
            TODO("Çektiğin fotoyu aldın")

        } else {

            super.onActivityResult(requestCode, resultCode, data)

        }
    }
}