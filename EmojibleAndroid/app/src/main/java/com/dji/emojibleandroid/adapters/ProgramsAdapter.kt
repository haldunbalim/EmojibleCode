package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.activities.CodeRunActivity
import com.dji.emojibleandroid.activities.ProgramActivity
import com.dji.emojibleandroid.models.ProgramModel

class ProgramsAdapter(val context: Context, var programs: MutableList<ProgramModel>) :
    RecyclerView.Adapter<ProgramsAdapter.MyViewHolder>() {

    companion object {

        val TAG: String = ProgramsAdapter::class.java.simpleName
        const val VIEW_TYPE_ONE = 1
        const val VIEW_TYPE_TWO = 2

    }

    private inner class View1ViewHolder(itemView: View) :
        ProgramsAdapter.MyViewHolder(itemView) {
        val add: ImageView = itemView.findViewById(R.id.addProgramImageView)
        fun bind(position: Int) {
            val recyclerViewModel = programs[position]
            add.setOnClickListener {

                val intent = Intent(context, ProgramActivity::class.java)
                context.startActivity(intent)

            }
        }
    }

    private inner class View2ViewHolder(itemView: View) :
        ProgramsAdapter.MyViewHolder(itemView) {
        val edit: Button = itemView.findViewById(R.id.editButton)
        val run: Button = itemView.findViewById(R.id.runButton)
        var title: TextView = itemView.findViewById(R.id.titleTextView)
        var code: TextView = itemView.findViewById(R.id.programCodeTextView)
        fun bind(position: Int) {
            val recyclerViewModel = programs[position]

            title.text = recyclerViewModel.name
            code.text = recyclerViewModel.code
            edit.setOnClickListener {

                val intent = Intent(context, ProgramActivity::class.java)
                intent.putExtra("type", "editProgram")
                intent.putExtra("code", code.text.toString())
                intent.putExtra("position", position)
                intent.putExtra("title", title.text.toString())
                context.startActivity(intent)

            }

            run.setOnClickListener {
                val intent = Intent(context, CodeRunActivity::class.java)
                intent.putExtra("CODE", recyclerViewModel.code)
                context.startActivity(intent)
            }
        }
    }


    fun update(program: MutableList<ProgramModel>) {
        this.programs = program
        notifyDataSetChanged()
    }

    fun updateSingle(program: ProgramModel, index: Int) {
        if (index > itemCount - 1) {
            throw IndexOutOfBoundsException("Supplied index $index is larger than the length $itemCount of the list")
        }
        programs[index] = program
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MyViewHolder {
        if (viewType == VIEW_TYPE_ONE) {
            return View1ViewHolder(
                LayoutInflater.from(parent.context)
                    .inflate(R.layout.list_grid_initial_program, parent, false)
            )
        }
        return View2ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.list_grid_program, parent, false)
        )


    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
        if (programs[position].viewType == VIEW_TYPE_ONE) {

            (holder as View1ViewHolder).bind(position)

        } else {

            (holder as View2ViewHolder).bind(position)

        }
    }

    override fun getItemViewType(position: Int): Int {
        return programs[position].viewType
    }

    override fun getItemCount(): Int {
        return programs.size
    }

    open inner class MyViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {

        var currentProgram: ProgramModel? = null
        var currentPosition: Int = 0

        init {
        }

    }
}

