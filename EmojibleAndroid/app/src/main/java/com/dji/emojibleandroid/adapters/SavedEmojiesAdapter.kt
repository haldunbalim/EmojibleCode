package com.dji.emojibleandroid.adapters

import android.content.Context
import android.text.Editable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.ModelTutorials
import com.dji.emojibleandroid.models.SavedEmojies
import kotlinx.android.synthetic.main.list_grid_savedemojies.view.*
import kotlinx.android.synthetic.main.list_grid_tutorial.view.*
import javax.microedition.khronos.egl.EGLDisplay

class SavedEmojiesAdapter(val context: Context, private val savedEmojies: List<SavedEmojies>) : RecyclerView.Adapter<SavedEmojiesAdapter.MyViewHolder>() {

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


            }
            itemView.deleteImageView.setOnClickListener {


            }
        }

        fun setData(savedEmoji: SavedEmojies?, pos: Int) {
            savedEmoji?.let {

                itemView.emojiEditTextView.text = savedEmoji.emoji as Editable?
                itemView.signEditTextView.text =  "\uD83D\uDC49" as Editable?
                itemView.textVoiceEditTextView.text = savedEmoji.value as Editable?

            }
            this.currentSavedEmoji = savedEmoji
            this.currentPosition = pos
        }
    }
}

