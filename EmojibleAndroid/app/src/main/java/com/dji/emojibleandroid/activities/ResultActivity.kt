package com.dji.emojibleandroid.activities

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.dji.emojibleandroid.Constants
import com.dji.emojibleandroid.R
import com.dji.emojibleandroid.showToast
import kotlinx.android.synthetic.main.activity_result.*

class ResultActivity: AppCompatActivity(){

    companion object{

        val TAG: String = ResultActivity::class.java.simpleName

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_result)
        //Safe Call ?.
        //Safe Call with let ?.let{}

        val bundle: Bundle? = intent.extras
        bundle?.let{

            val msg = bundle.getString(Constants.USER_MSG_KEY)
            msg?.let { it1 -> showToast(it1) }
            resultTextView.text = msg

        }
    }

}