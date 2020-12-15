package com.dji.emojibleandroid.services

import com.google.firebase.auth.*

// import com.facebook.AccessToken

class AuthenticationManager private constructor() {
    val firebaseAuth = FirebaseAuth.getInstance()
    var currentUser: FirebaseUser? = null
    val notificationCenter = NotificationCenter.instance

    fun startListeningForAuthChanges() {
        firebaseAuth.addAuthStateListener {
            currentUser = FirebaseAuth.getInstance().currentUser
            notificationCenter.post(Changes.authStateChanged, null)
        }
    }

    fun userLoggedIn(): Boolean {
        return firebaseAuth.currentUser != null
    }

    // Email Functions
    fun checkIfUserWithEmailExists(email: String, completion: (Any?) -> Unit) {
        firebaseAuth.fetchSignInMethodsForEmail(email).addOnCompleteListener {
            if (it.isSuccessful) {
                completion(it.result)
            } else {
                completion(it.exception)
            }
        }
    }

    fun createUserWithEmailAndPassword(
        email: String,
        password: String,
        completion: ((String?) -> Void)
    ) {
        firebaseAuth.createUserWithEmailAndPassword(email, password).addOnCompleteListener {
            if (it.isSuccessful) {
                completion(null)
            } else {
                completion(it.exception?.message)
            }
        }
    }

    fun signInWithEmailAndPassword(
        email: String,
        password: String,
        completion: ((String?) -> Void)
    ) {
        firebaseAuth.signInWithEmailAndPassword(email, password).addOnCompleteListener {
            if (it.isSuccessful) {
                completion(null)
            } else {
                completion(it.exception?.message)
            }
        }
    }

//    // Facebook login functions
//
//    fun facebookSignIn(completion: ((String?) -> Void)){
//        //also registers user if there is no user registered with that username
//
//        val credential = FacebookAuthProvider.getCredential(AccessToken.current!.tokenString)
//        //firebaseLogin(credential, completion: completion)
//    }

    private object HOLDER {
        val INSTANCE = AuthenticationManager()
    }

    companion object {
        val instance: AuthenticationManager by lazy { HOLDER.INSTANCE }
    }
}