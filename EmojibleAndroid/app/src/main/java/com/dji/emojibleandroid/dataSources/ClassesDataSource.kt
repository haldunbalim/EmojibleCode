package com.dji.emojibleandroid.dataSources

import com.google.firebase.firestore.ListenerRegistration
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase

class ClassesDataSource {
    var database = Firebase.firestore
    var snapShotListener: ListenerRegistration? = null

    private object HOLDER {
        val INSTANCE = ClassesDataSource()
    }

    companion object {
        val instance: ClassesDataSource by lazy { HOLDER.INSTANCE }
    }
}