package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.DialogInterface
import android.graphics.Color
import android.media.MediaPlayer
import android.media.MediaRecorder
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.AssignmentModel
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.SavedEmojies
import com.dji.emojibleandroid.models.ValueType
import com.dji.emojibleandroid.services.Changes
import com.dji.emojibleandroid.services.NotificationCenter
import com.dji.emojibleandroid.utils.EmojiUtils
import kotlinx.android.synthetic.main.dialog_emojies.view.*
import kotlinx.android.synthetic.main.list_grid_savedemojies.view.*
import java.io.IOException

class SavedEmojiesAdapter(
    val context: Context,
    var assignments: MutableList<AssignmentModel>,
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
        val savedEmoji = assignments[position]
        holder.setData(savedEmoji, position)
    }

    override fun getItemCount(): Int {
        return assignments.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var currentAssignment: AssignmentModel? = null
        var currentPosition: Int = 0

        init {
            itemView.setOnClickListener() {


            }

            itemView.textVoiceEditTextView.setOnClickListener {

                if (itemView.textVoiceEditTextView.text.toString() == "\uD83C\uDFA7") {

                    val tempFileName = fileName.substring(
                        0,
                        fileName.length - 4
                    ) + currentAssignment?.identifier.toString() + ".3gp"
                    startPlaying(tempFileName)

                }

            }

            itemView.editImageView.setOnClickListener {


                val builder = AlertDialog.Builder(context)
                builder.setTitle(currentAssignment?.identifier.toString())
                val view = LayoutInflater.from(context).inflate(R.layout.dialog_emojies, null)
                builder.setView(view)
                builder.setNegativeButton("Close", DialogInterface.OnClickListener { _, _ -> })
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
                    programAssignmentOnClickAction(alertDialog)
                }

                view.functionImageView.setOnClickListener {
                    programAssignmentOnClickAction(alertDialog)
                }

            }
            itemView.deleteImageView.setOnClickListener {
                assignments.removeAt(currentPosition)
                NotificationCenter.instance.post(Changes.assignmentsChanged, currentAssignment)
                notifyDataSetChanged()
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
                val result = AssignmentModel(currentAssignment!!.identifier, text)
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
            ) + currentAssignment!!.identifier.toString() + ".3gp"
            cancelButton?.setOnClickListener { customDialog.dismiss() }
            recordButton?.setOnClickListener {

                count++
                if (count != 1) {
                    recordButton.setTextColor(Color.BLACK)
                    count = 0
                    stopRecording()
                    startPlaying(tempFileName)
                } else {
                    recordButton.setTextColor(Color.RED)
                    startRecording(tempFileName)
                }
            }
            assignButton?.setOnClickListener {
                stopPlaying()
                val result =
                    AssignmentModel(currentAssignment!!.identifier, tempFileName)
                NotificationCenter.instance.post(
                    Changes.assignmentsChanged,
                    null,
                    result
                )
                customDialog.dismiss()
                alertDialog.dismiss()

            }
        }

        private fun programAssignmentOnClickAction(alertDialog: AlertDialog) {
            val dialogView = LayoutInflater.from(context).inflate(R.layout.popup_text, null)
            val customDialog = AlertDialog.Builder(context)
                .setView(dialogView)
                .show()

            val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)
            val assignButton = customDialog.findViewById<Button>(R.id.assignButton)

            cancelButton?.setOnClickListener { customDialog.dismiss() }


            assignButton?.setOnClickListener {

                val text = customDialog.findViewById<EditText>(R.id.textEditTV)?.text.toString()
                val result = AssignmentModel(
                    currentAssignment!!.identifier,
                    CodeModel(currentAssignment!!.identifier.toString(), text)
                )
                NotificationCenter.instance.post(
                    Changes.assignmentsChanged,
                    null,
                    result
                )
                customDialog.dismiss()
                alertDialog.dismiss()

            }
        }

        fun setData(savedEmoji: AssignmentModel?, pos: Int) {
            savedEmoji?.let {

                itemView.emojiEditTextView.text = savedEmoji.identifier
                itemView.signEditTextView.text = "\uD83D\uDC49"
                itemView.textVoiceEditTextView.text =
                    when (savedEmoji.value.type) {
                        ValueType.Voice -> {
                            "\uD83C\uDFA7"
                        }
                        ValueType.Code -> {
                            (savedEmoji.value.value as CodeModel).code
                        }
                        else -> {
                            savedEmoji.value.value.toString()
                        }
                    }

            }
            this.currentAssignment = savedEmoji
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

    fun update(assignments: MutableList<AssignmentModel>) {
        this.assignments = assignments
        notifyDataSetChanged()
    }

    fun updateSingle(assignmentModel: AssignmentModel) {
        if (assignmentModel in assignments) {
            assignments[assignments.indexOf(assignmentModel)] = assignmentModel
        } else {
            assignments.add(assignmentModel)
        }
        notifyDataSetChanged()
    }
}

