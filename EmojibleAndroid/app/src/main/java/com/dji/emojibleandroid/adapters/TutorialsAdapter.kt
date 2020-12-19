package com.dji.emojibleandroid.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.ModelTutorials
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.list_grid_tutorial.view.*
import java.lang.IndexOutOfBoundsException

class TutorialsAdapter(val context: Context, var tutorials: MutableList<CodeModel>) :
    RecyclerView.Adapter<TutorialsAdapter.MyViewHolder>() {

    companion object {

        val TAG: String = TutorialsAdapter::class.java.simpleName

    }

    fun update(tutorials: MutableList<CodeModel>) {
        this.tutorials = tutorials
        notifyDataSetChanged()
    }

    fun updateSingle(tutorial: CodeModel, index: Int) {
        if (index > itemCount - 1) {
            throw IndexOutOfBoundsException("Supplied index $index is larger than the length $itemCount of the list")
        }
        tutorials[index] = tutorial
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        val view =
            LayoutInflater.from(parent.context).inflate(R.layout.list_grid_tutorial, parent, false)
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

        var currentTutorial: CodeModel? = null
        var currentPosition: Int = 0

        init {
            itemView.setOnClickListener() {

                currentTutorial?.let {

                }
            }

            itemView.runButton.setOnClickListener {


            }
            itemView.showButton.setOnClickListener {


            }
        }

        fun setData(tutorial: CodeModel?, pos: Int) {
            tutorial?.let {

                itemView.titleTextView.text = tutorial.name
                itemView.tutorialCode.text = tutorial.code
            }
            this.currentTutorial = tutorial
            this.currentPosition = pos
        }
    }
}

