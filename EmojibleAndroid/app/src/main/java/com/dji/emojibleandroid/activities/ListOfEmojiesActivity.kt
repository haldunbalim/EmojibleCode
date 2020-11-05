package com.dji.emojibleandroid.activities

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import com.dji.emojibleandroid.adapters.EmojiesAdapter
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.models.Supplier
import kotlinx.android.synthetic.main.activity_list_emojies.*

class ListOfEmojiesActivity : AppCompatActivity(){

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_list_emojies)
        setupRecyclerView()

    }

    private fun setupRecyclerView() {
        val layoutManager = LinearLayoutManager(this)
        layoutManager.orientation = LinearLayoutManager.VERTICAL
        recyclerView.layoutManager = layoutManager
        val adapter = EmojiesAdapter(this, Supplier.emojies)
        recyclerView.adapter = adapter
    }

}