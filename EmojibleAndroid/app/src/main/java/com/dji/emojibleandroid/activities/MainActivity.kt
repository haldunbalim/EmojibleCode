package com.dji.emojibleandroid.activities

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.dji.emojibleandroid.interpreter.GlobalMemory

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
