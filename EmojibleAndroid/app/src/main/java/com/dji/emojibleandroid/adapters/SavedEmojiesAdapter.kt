package com.dji.emojibleandroid.adapters

import android.content.Context
import android.text.Editable
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
import kotlinx.android.synthetic.main.list_grid_savedemojies.view.*
import kotlinx.android.synthetic.main.list_grid_tutorial.view.*
import javax.microedition.khronos.egl.EGLDisplay

class SavedEmojiesAdapter(val context: Context, private var savedEmojies: MutableList<SavedEmojies>) : RecyclerView.Adapter<SavedEmojiesAdapter.MyViewHolder>() {

    companion object {

        val TAG: String = SavedEmojiesAdapter::class.java.simpleName

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.list_grid_savedemojies, parent, false)
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

            itemView.editImageView.setOnClickListener{


                val dialogView = LayoutInflater.from(context).inflate(R.layout.popup_text,null)
                val customDialog = AlertDialog.Builder(context)
                    .setView(dialogView)
                    .show()

                val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)
                val assignButton = customDialog.findViewById<Button>(R.id.assignButton)

                cancelButton?.setOnClickListener { customDialog.dismiss() }

                savedEmojies.removeAt(currentPosition)
                assignButton?.setOnClickListener {

                    val text = customDialog.findViewById<EditText>(R.id.textEditTV)?.text.toString()
                    val result = SavedEmojies(currentSavedEmoji?.emoji, text)
                    EmojiUtils.savedEmojies.add(EmojiUtils.savedEmojies.size,result)
                    customDialog.dismiss()

                }



            }
            itemView.deleteImageView.setOnClickListener {

                savedEmojies.removeAt(currentPosition)

            }
        }

        fun setData(savedEmoji: SavedEmojies?, pos: Int) {
            savedEmoji?.let {

                itemView.emojiEditTextView.text = savedEmoji.emoji
                itemView.signEditTextView.text =  "\uD83D\uDC49"
                itemView.textVoiceEditTextView.text = savedEmoji.value

            }
            this.currentSavedEmoji = savedEmoji
            this.currentPosition = pos
        }
    }
}

