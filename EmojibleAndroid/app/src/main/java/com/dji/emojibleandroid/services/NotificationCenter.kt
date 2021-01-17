package com.dji.emojibleandroid.services

import java.util.*

class NotificationCenter private constructor() {
    var observables: EnumMap<Changes, MutableList<Observer?>> = EnumMap(Changes::class.java)
    fun addObserver(notification: Changes, observer: Observer?) {
        var observable = observables[notification]
        if (observable == null) {
            observable = mutableListOf()
            observables[notification] = observable
        }
        observable.add(observer)
    }

    fun removeObserver(notification: Changes?, observer: Observer?) {
        observables[notification]?.remove(observer)
    }

    fun post(notification: Changes?, `object`: Any?, userInfo: Any? = null) {
        val observable = observables[notification]

        for (o in observable!!) {
            o!!.update(Observable(), userInfo)
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