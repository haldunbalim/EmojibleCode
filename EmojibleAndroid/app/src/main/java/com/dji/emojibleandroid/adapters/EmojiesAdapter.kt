package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.DialogInterface
import android.view.*
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.SavedEmojies
import com.dji.emojibleandroid.showToast
import com.dji.emojibleandroid.utils.EmojiUtils.savedEmojies
import kotlinx.android.synthetic.main.dialog_emojies.view.*
import kotlinx.android.synthetic.main.list_grid_emoji.view.*
import kotlinx.android.synthetic.main.popup_text.view.*

class EmojiesAdapter(val context: Context, private val emojies: List<String>) : RecyclerView.Adapter<EmojiesAdapter.MyViewHolder>() {

    companion object {

        val TAG: String = EmojiesAdapter::class.java.simpleName

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.list_grid_emoji, parent, false)
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
                val view = LayoutInflater.from(context).inflate(R.layout.dialog_emojies,null)
                builder.setView(view)
                builder.setNegativeButton("Close", DialogInterface.OnClickListener { _, _ ->  })
                val alertDialog : AlertDialog = builder.create()
                alertDialog.show()

                context.showToast(currentEmoji!!.toString() + "Clicked !")
                view.textTextView.setOnClickListener {


                    val dialogView = LayoutInflater.from(context).inflate(R.layout.popup_text,null)
                    val customDialog = AlertDialog.Builder(context)
                        .setView(dialogView)
                        .show()

                    val cancelButton = customDialog.findViewById<Button>(R.id.cancelButton)
                    val assignButton = customDialog.findViewById<Button>(R.id.assignButton)

                    cancelButton?.setOnClickListener { customDialog.dismiss() }


                    assignButton?.setOnClickListener {

                        val text = customDialog.findViewById<EditText>(R.id.textEditTV)?.text.toString()
                        val result = SavedEmojies(currentEmoji!!.toString(), text)
                        savedEmojies.add(savedEmojies.size,result)
                        customDialog.dismiss()
                        alertDialog.dismiss()

                    }


                    }

                view.voiceTextView.setOnClickListener {


                }

                view.functionTextView.setOnClickListener {



                }

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
}

