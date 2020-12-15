package com.dji.emojibleandroid.services

import com.dji.emojibleandroid.models.CodeModel
import java.util.*

class NotificationCenter private constructor() {
    var observables: EnumMap<Changes, Observable?> = EnumMap(Changes::class.java)
    fun addObserver(notification: Changes, observer: Observer?) {
        var observable: Observable? = observables[notification]
        if (observable == null) {
            observable = Observable()
            observables[notification] = observable
        }
        observable.addObserver(observer)
    }

    fun removeObserver(notification: Changes?, observer: Observer?) {
        observables[notification]?.deleteObserver(observer)
    }

    fun post(notification: Changes?, `object`: Any?, userInfo: Any? = null) {
        val observable: Observable? = observables[notification]
        observable.let {
            it?.hasChanged()
            it?.notifyObservers(`object`)
        }

    }

    private object HOLDER {
        val INSTANCE = NotificationCenter()
    }

    companion object {
        val instance: NotificationCenter by lazy { HOLDER.INSTANCE }
    }
}

enum class Changes(value: String) {
    userModelChagend("userModelChanged"),
    authStateChanged("authStateChanged"),
    assignmentsChanged("assignmentsChanged"),
    defaultTutorialsChanged("defaultTutorialsChanged"),
    programsChanged("programsChanged"),
    teacherTutorialsChanged("teacherTutorialsChanged");
}