package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.activities.ProgramActivity
import com.dji.emojibleandroid.models.CodeModel
import com.dji.emojibleandroid.models.serializers.ProgramModel
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.list_grid_initial_program.view.*
import kotlinx.android.synthetic.main.list_grid_program.view.*
import kotlinx.android.synthetic.main.list_grid_tutorial.view.*
import kotlinx.android.synthetic.main.list_grid_tutorial.view.titleTextView
import java.lang.IndexOutOfBoundsException

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
        fun bind(position: Int) {
            val recyclerViewModel = programs[position]
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
                LayoutInflater.from(parent.context).inflate(R.layout.list_grid_initial_program, parent, false)
            )
        }
        return View2ViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.list_grid_program, parent, false)
        )


    }

    override fun onBindViewHolder(holder: MyViewHolder, position: Int) {
       if(programs[position].viewType == VIEW_TYPE_ONE){

           (holder as View1ViewHolder).bind(position)

       }else {

           val program = programs[position]
           holder.setData(program, position)

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

            itemView.setOnClickListener() {

                context.showToast(currentProgram?.name + " is clicked")

            }
        }


        fun setData(program: ProgramModel?, pos: Int) {

            program?.let {

                itemView.titleTextView.text = program.name
                itemView.programCodeTextView.text = program.code

            }


            this.currentProgram = program
            this.currentPosition = pos
        }
    }
}

