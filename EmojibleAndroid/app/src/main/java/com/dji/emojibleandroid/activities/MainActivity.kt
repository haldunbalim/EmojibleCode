package com.dji.emojibleandroid.activities

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.interpreter.GlobalMemory
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    companion object{
        val TAG: String = MainActivity::class.java.simpleName
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GlobalMemory.sharedPreferences = getSharedPreferences(packageName + "_preferences", Context.MODE_PRIVATE)
        val intent = Intent(this, NoUserActivity::class.java)
        startActivity(intent)

    }
}
