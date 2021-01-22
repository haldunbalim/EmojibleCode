package com.dji.emojibleandroid.adapters

import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.activities.StudentsInClassActivity
import com.dji.emojibleandroid.dataSources.TeacherClassDataSource
import com.dji.emojibleandroid.models.ClassModel
import kotlinx.android.synthetic.main.list_class.view.*

class CreateClassAdapter(val context: Context, var classes: MutableList<ClassModel>) :
    RecyclerView.Adapter<CreateClassAdapter.ClassesViewHolder>() {

    inner class ClassesViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var currentClass: ClassModel? = null
        var currentPosition = 0

        init {
            itemView.classNameTextView.setOnClickListener {
                val intent = Intent(context, StudentsInClassActivity::class.java)
                intent.putExtra("className", currentClass?.className)
                intent.putExtra("classId", currentClass?.id)
                context.startActivity(intent)
            }
            itemView.classIdTextView.setOnClickListener {
                val intent = Intent(context, StudentsInClassActivity::class.java)
                intent.putExtra("className", currentClass?.className)
                intent.putExtra("classId", currentClass?.id)
                context.startActivity(intent)
            }
            itemView.deleteClassImageView.setOnClickListener {
                val classModel = classes[currentPosition]
                TeacherClassDataSource.instance.removeClass(classModel)
                classes.removeAt(currentPosition)
                notifyDataSetChanged()
            }
        }

        fun setData(codeClass: ClassModel?, pos: Int) {
            codeClass?.let {
                itemView.classNameTextView.text = "Class Name: ${it.className}"
                itemView.classIdTextView.text = "Class Id: ${it.id}"
            }
            currentClass = codeClass
            currentPosition = pos
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ClassesViewHolder {
        return ClassesViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.list_class, parent, false)
        )
    }

    override fun onBindViewHolder(holder: ClassesViewHolder, position: Int) {
        val currentClass = classes[position]
        holder.setData(currentClass, position)
    }

    override fun getItemCount(): Int {
        return classes.size
    }

    fun update(classes: MutableList<ClassModel>) {
        this.classes = classes
        notifyDataSetChanged()
    }
}