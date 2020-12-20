package com.dji.emojibleandroid.adapters

import android.content.Context
import android.graphics.Color.*
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.util.Log
import android.view.*
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.SavedEmojies
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.utils.EmojiUtils.savedEmojies
import kotlinx.android.synthetic.main.dialog_emojies.view.*
import kotlinx.android.synthetic.main.list_grid_emoji.view.*
import java.io.IOException

class EmojiesAdapter(
    val context: Context,
    private val emojies: List<String>,
    var fileName: String
) :
    RecyclerView.Adapter<EmojiesAdapter.MyViewHolder>() {

    private val LOG_TAG = "AudioRecordTest"
    private var recorder: MediaRecorder? = null
    private var player: MediaPlayer? = null


    companion object {

        val TAG: String = EmojiesAdapter::class.java.simpleName

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.list_grid_emoji, parent, false)
        return MyViewHolder(view)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        val emoji = emojies[position]
        holder.setData(emoji, position)
    }

    override fun getItemCount(): Int {
        return emojies.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var currentEmoji: CharSequence? = null
        var currentPosition: Int = 0

        init {
            itemView.emojiButton.setOnClickListener() {

                val builder = AlertDialog.Builder(context)
                builder.setTitle(currentEmoji!!.toString())
                val view = LayoutInflater.from(context).inflate(R.layout.dialog_emojies, null)
                builder.setView(view)
                builder.setNegativeButton("Close") { _, _ -> }
                val alertDialog: AlertDialog = builder.create()
                alertDialog.show()

                view.textTextView.setOnClickListener {
                    stringAssignmentOnClickAction(alertDialog)
                }
                view.textImageView.setOnClickListener {
                    stringAssignmentOnClickAction(alertDialog)
                }

                view.voiceTextView.setOnClickListener {
                    voiceAssignmentOnClickAction(alertDialog)
                }

                view.voiceImageView.setOnClickListener {
                    voiceAssignmentOnClickAction(alertDialog)
                }

                view.functionTextView.setOnClickListener {


                }

                view.functionImageView.setOnClickListener {


                }

            }

        }


        private fun stringAssignmentOnClickAction(alertDialog: AlertDialog) {
            val dialogView = LayoutInflater.from(context).inflate(R.layout.popup_text, null)
            val customDialog = AlertDialog.Builder(context)
                .setView(dialogView)
                .show()

            val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)
            val assignButton = customDialog.findViewById<Button>(R.id.assignButton)

            cancelButton?.setOnClickListener { customDialog.dismiss() }


            assignButton?.setOnClickListener {

                val text = customDialog.findViewById<EditText>(R.id.textEditTV)?.text.toString()
                val result = AssignmentModel(currentEmoji!!, text)
                NotificationCenter.instance.post(
                    Changes.assignmentsChanged,
                    null,
                    result
                )
                customDialog.dismiss()
                alertDialog.dismiss()

            }
        }

        private fun voiceAssignmentOnClickAction(alertDialog: AlertDialog) {

            var count = 0
            val dialogView =
                LayoutInflater.from(context).inflate(R.layout.popup_voice, null)
            val customDialog = AlertDialog.Builder(context)
                .setView(dialogView)
                .show()

            val recordButton = customDialog.findViewById<Button>(R.id.recordButton)
            val assignButton = customDialog.findViewById<Button>(R.id.assignButton)
            val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)


            val tempFileName = fileName.substring(
                0,
                fileName.length - 4
            ) + currentEmoji!!.toString() + ".3gp"
            cancelButton?.setOnClickListener { customDialog.dismiss() }
            recordButton?.setOnClickListener {

                count++
                if (count != 1) {
                    recordButton.setTextColor(BLACK)
                    count = 0
                    stopRecording()
                    startPlaying(tempFileName)
                } else {
                    recordButton.setTextColor(RED)
                    startRecording(tempFileName)
                }
            }
            assignButton?.setOnClickListener {
                stopPlaying()
                val result =
                    AssignmentModel(currentEmoji!!, tempFileName)
                NotificationCenter.instance.post(
                    Changes.assignmentsChanged,
                    null,
                    result
                )
                customDialog.dismiss()
                alertDialog.dismiss()

            }
        }

        fun setData(emoji: String, pos: Int) {
            emoji?.let {

                itemView.emojiButton.text = emoji

            }
            this.currentEmoji = emoji
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

