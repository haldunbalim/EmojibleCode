package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.DialogInterface
import android.graphics.Color
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.text.Editable
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AlertDialog
import androidx.core.os.persistableBundleOf
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.ModelTutorials
import com.dji.emojibleandroid.models.SavedEmojies
import com.dji.emojibleandroid.utils.EmojiUtils
import kotlinx.android.synthetic.main.dialog_emojies.view.*
import kotlinx.android.synthetic.main.list_grid_savedemojies.view.*
import kotlinx.android.synthetic.main.list_grid_tutorial.view.*
import java.io.IOException
import javax.microedition.khronos.egl.EGLDisplay

class SavedEmojiesAdapter(
    val context: Context,
    private var savedEmojies: MutableList<SavedEmojies>,
    var fileName: String
) : RecyclerView.Adapter<SavedEmojiesAdapter.MyViewHolder>() {

    private val LOG_TAG = "AudioRecordTest"
    private var recorder: MediaRecorder? = null
    private var player: MediaPlayer? = null

    companion object {

        val TAG: String = SavedEmojiesAdapter::class.java.simpleName

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.list_grid_savedemojies, parent, false)
        return MyViewHolder(view)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        val savedEmoji = savedEmojies[position]
        holder.setData(savedEmoji, position)
    }

    override fun getItemCount(): Int {
        return savedEmojies.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var currentSavedEmoji: SavedEmojies? = null
        var currentPosition: Int = 0

        init {
            itemView.setOnClickListener() {


            }

            itemView.textVoiceEditTextView.setOnClickListener {

                if (itemView.textVoiceEditTextView.text.toString() == "\uD83C\uDFA7" ){

                    var tempFileName = fileName.substring(0,fileName.length-4) + currentSavedEmoji?.emoji.toString() + ".3gp"
                    startPlaying(tempFileName)

                }

            }

            itemView.editImageView.setOnClickListener {


                val builder = AlertDialog.Builder(context)
                builder.setTitle(currentSavedEmoji?.emoji.toString())
                val view = LayoutInflater.from(context).inflate(R.layout.dialog_emojies, null)
                builder.setView(view)
                builder.setNegativeButton("Close", DialogInterface.OnClickListener { _, _ -> })
                val alertDialog: AlertDialog = builder.create()
                alertDialog.show()

                view.textTextView.setOnClickListener {

                    val dialogView = LayoutInflater.from(context).inflate(R.layout.popup_text, null)
                    val customDialog = AlertDialog.Builder(context)
                        .setView(dialogView)
                        .show()

                    val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)
                    val assignButton = customDialog.findViewById<Button>(R.id.assignButton)

                    cancelButton?.setOnClickListener { customDialog.dismiss() }


                    assignButton?.setOnClickListener {

                        val text =
                            customDialog.findViewById<EditText>(R.id.textEditTV)?.text.toString()
                        val result = SavedEmojies(currentSavedEmoji?.emoji.toString(), text)
                        EmojiUtils.savedEmojies.add(EmojiUtils.savedEmojies.size, result)
                        customDialog.dismiss()
                        alertDialog.dismiss()

                    }
                }
                view.textImageView.setOnClickListener {

                    val dialogView = LayoutInflater.from(context).inflate(R.layout.popup_text, null)
                    val customDialog = AlertDialog.Builder(context)
                        .setView(dialogView)
                        .show()

                    val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)
                    val assignButton = customDialog.findViewById<Button>(R.id.assignButton)

                    cancelButton?.setOnClickListener { customDialog.dismiss() }


                    assignButton?.setOnClickListener {

                        val text =
                            customDialog.findViewById<EditText>(R.id.textEditTV)?.text.toString()
                        val result = SavedEmojies(currentSavedEmoji?.emoji.toString(), text)
                        EmojiUtils.savedEmojies.add(EmojiUtils.savedEmojies.size, result)
                        customDialog.dismiss()
                        alertDialog.dismiss()

                    }
                }

                view.voiceTextView.setOnClickListener {

                    var count = 0
                    val dialogView =
                        LayoutInflater.from(context).inflate(R.layout.popup_voice, null)
                    val customDialog = AlertDialog.Builder(context)
                        .setView(dialogView)
                        .show()

                    var recordButton = customDialog.findViewById<Button>(R.id.recordButton)
                    val assignButton = customDialog.findViewById<Button>(R.id.assignButton)
                    val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)



                    cancelButton?.setOnClickListener { customDialog.dismiss() }
                    recordButton?.setOnClickListener {

                        count++
                        if (count != 1) {

                            recordButton?.setTextColor(Color.BLACK)
                            count = 0
                            stopRecording()
                            var tempFileName  = fileName.substring(0,fileName.length-4) + currentSavedEmoji?.emoji.toString() + ".3gp"
                            startPlaying(tempFileName)

                        } else {

                            recordButton?.setTextColor(Color.RED)
                            var tempFileName  = fileName.substring(0,fileName.length-4) + currentSavedEmoji?.emoji.toString() + ".3gp"
                            startRecording(tempFileName)

                        }
                    }
                    assignButton?.setOnClickListener {

                        stopPlaying()
                        val result = SavedEmojies(currentSavedEmoji?.emoji.toString(), "\uD83C\uDFA7")
                        EmojiUtils.savedEmojies.add(EmojiUtils.savedEmojies.size, result)
                        customDialog.dismiss()
                        alertDialog.dismiss()

                    }

                }

                view.voiceImageView.setOnClickListener {


                    var count = 0
                    val dialogView =
                        LayoutInflater.from(context).inflate(R.layout.popup_voice, null)
                    val customDialog = AlertDialog.Builder(context)
                        .setView(dialogView)
                        .show()

                    var recordButton = customDialog.findViewById<Button>(R.id.recordButton)
                    val assignButton = customDialog.findViewById<Button>(R.id.assignButton)
                    val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)

                    cancelButton?.setOnClickListener { customDialog.dismiss() }

                    recordButton?.setOnClickListener {

                        count++
                        if (count != 1) {

                            recordButton?.setTextColor(Color.BLACK)
                            count = 0
                            stopRecording()
                            var tempFileName  = fileName.substring(0,fileName.length-4) + currentSavedEmoji?.emoji.toString() + ".3gp"
                            startPlaying(tempFileName)

                        } else {

                            recordButton?.setTextColor(Color.RED)
                            var tempFileName = fileName.substring(0,fileName.length-4) + currentSavedEmoji?.emoji.toString() + ".3gp"
                            startRecording(tempFileName)

                        }
                    }

                    assignButton?.setOnClickListener {

                        stopPlaying()

                        val result = SavedEmojies(currentSavedEmoji?.emoji.toString(), "\uD83C\uDFA7")
                        EmojiUtils.savedEmojies.add(EmojiUtils.savedEmojies.size, result)
                        customDialog.dismiss()
                        alertDialog.dismiss()
                    }
                }


            }
            itemView.deleteImageView.setOnClickListener {

                savedEmojies.removeAt(currentPosition)

            }
        }

        fun setData(savedEmoji: SavedEmojies?, pos: Int) {
            savedEmoji?.let {

                itemView.emojiEditTextView.text = savedEmoji.emoji
                itemView.signEditTextView.text = "\uD83D\uDC49"
                itemView.textVoiceEditTextView.text = savedEmoji.value

            }
            this.currentSavedEmoji = savedEmoji
            this.currentPosition = pos
        }
    }


    protected fun startPlaying(fileName: String) {
        player = MediaPlayer().apply {
            try {
                setDataSource(fileName)
                prepare()
                start()
            } catch (e: IOException) {
                Log.e(LOG_TAG, "prepare() failed")
            }
        }
    }

    protected fun stopPlaying() {
        player?.release()
        player = null
    }

    protected fun startRecording(fileName: String) {
        recorder = MediaRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP)
            setOutputFile(fileName)
            setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)

            try {
                prepare()
            } catch (e: IOException) {
                Log.e(LOG_TAG, "prepare() failed")
            }

            start()
        }
    }

    protected fun stopRecording() {
        recorder?.apply {
            stop()
            release()
        }
        recorder = null
    }
}

