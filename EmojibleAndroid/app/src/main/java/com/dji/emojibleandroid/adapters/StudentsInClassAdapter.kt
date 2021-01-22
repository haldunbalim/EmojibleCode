package com.dji.emojibleandroid.adapters

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.StudentModel
import kotlinx.android.synthetic.main.list_student_in_class.view.*

class StudentsInClassAdapter(val context: Context, var students: MutableList<StudentModel>) :
    RecyclerView.Adapter<StudentsInClassAdapter.StudentInClassViewHolder>() {
    inner class StudentInClassViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var currentStudent: StudentModel? = null
        var currentPosition = 0

        fun setData(student: StudentModel, position: Int) {
            itemView.studentNameInClassTextView.text = "${student.name} ${student.surname}"
            itemView.studentEmailInClassTextView.text = "${student.email}"
            currentStudent = student
            currentPosition = position
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StudentInClassViewHolder {
        return StudentInClassViewHolder(
            LayoutInflater.from(parent.context)
                .inflate(R.layout.list_student_in_class, parent, false)
        )
    }

    override fun onBindViewHolder(holder: StudentInClassViewHolder, position: Int) {
        val currentStudent = students[position]
        holder.setData(currentStudent, position)
    }

    override fun getItemCount(): Int {
        return students.size
    }

    fun update(students: MutableList<StudentModel>) {
        this.students = students
        notifyDataSetChanged()
    }
}