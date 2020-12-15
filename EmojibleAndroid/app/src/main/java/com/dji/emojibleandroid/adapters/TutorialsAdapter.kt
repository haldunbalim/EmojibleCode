package com.dji.emojibleandroid.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.ModelTutorials
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.list_grid_tutorial.view.*

class TutorialsAdapter(val context: Context, private val tutorials: List<ModelTutorials>) : RecyclerView.Adapter<TutorialsAdapter.MyViewHolder>() {

    companion object {

        val TAG: String = com.dji.emojibleandroid.adapters.TutorialsAdapter::class.java.simpleName

    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view = LayoutInflater.from(parent.context).inflate(R.layout.list_grid_tutorial, parent, false)
        return MyViewHolder(view)
    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        val tutorial = tutorials[position]
        holder.setData(tutorial, position)
    }

    override fun getItemCount(): Int {
        return tutorials.size
    }

    inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var currentTutorial: ModelTutorials? = null
        var currentPosition: Int = 0

        init {
            itemView.setOnClickListener() {

                currentTutorial?.let {

                    context.showToast(currentTutorial!!.title + "Clicked !")
                }
            }

            itemView.runButton.setOnClickListener{

                context.showToast("Run Button is pressed")

            }
            itemView.showButton.setOnClickListener {

                context.showToast("Show Button is pressed")

            }
        }

        fun setData(tutorial: ModelTutorials?, pos: Int) {
            tutorial?.let {

                itemView.titleTextView.text = tutorial.title

            }
            this.currentTutorial = tutorial
            this.currentPosition = pos
        }
    }
}

