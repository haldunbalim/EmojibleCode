package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.models.Emoji
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.list_emojies.view.*

class EmojiesAdapter(val context: Context, private val emojies: List<Emoji>) : RecyclerView.Adapter<EmojiesAdapter.MyViewHolder>(){

    companion object{

        val TAG: String = EmojiesAdapter::class.java.simpleName

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = LayoutInflater.from(context).inflate(R.layout.list_emojies, parent, false)
        return MyViewHolder(view)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        val emoji = emojies[position]
        holder.setData(emoji,position)
    }

    override fun getItemCount(): Int {
        return emojies.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView){

        var currentEmoji: Emoji? = null
        var currentPosition: Int = 0

        init{
            itemView.setOnClickListener(){

                 currentEmoji?.let {

                    context.showToast(currentEmoji!!.title + "Clicked !")
                }
            }

            itemView.imageView.setOnClickListener(){

                currentEmoji?.let {

                    val message: String = "This emoji is: " + currentEmoji!!.title
                    val intent = Intent()
                    intent.action = Intent.ACTION_SEND
                    intent.putExtra(Intent.EXTRA_TEXT, message)
                    intent.type = "text/plain"
                    context.startActivity(Intent.createChooser(intent,"Share with: "))

                }




            }
        }
        fun setData(emoji: Emoji?, pos: Int){
            emoji?.let {

                itemView.textView.text = emoji.title

            }
            this.currentEmoji = emoji
            this.currentPosition = pos
        }
    }


}