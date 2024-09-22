importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
const firebaseConfig = {
    apiKey: "AIzaSyAu1OvJ-RskKas1fgmHA_GSn-9DWpNmZwU",
    authDomain: "notificationwebpreecha.firebaseapp.com",
    projectId: "notificationwebpreecha",
    storageBucket: "notificationwebpreecha.appspot.com",
    messagingSenderId: "82487684572",
    appId: "1:82487684572:web:3984575ad7ee5002a4b319",
    measurementId: "G-CW6RVYCX88"
  };

firebase.initializeApp(firebaseConfig);

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();
messaging.onBackgroundMessage((message)=>{
    console.log("onBackgroundMessage",message);
});