package com.dji.emojibleandroid.models

data class Emoji(var title: String)

object Supplier{

    val emojies = listOf<Emoji>(
        Emoji("Backhand Index Pointing Right"),
        Emoji("Thumbs up"),
        Emoji("Flexed Biceps"),
        Emoji("Nose"),
        Emoji("Ear"),
        Emoji("Brain"),
        Emoji("Eye")
    )
}