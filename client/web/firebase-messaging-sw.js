// Firebase Cloud Messaging Service Worker
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js');

// Initialize Firebase in the service worker
firebase.initializeApp({
  apiKey: 'AIzaSyBXjRbRe0g1mpyGcXaFHT-291dI7TfAZao',
  authDomain: 'the-mob-state.firebaseapp.com',
  projectId: 'the-mob-state',
  storageBucket: 'the-mob-state.firebasestorage.app',
  messagingSenderId: '572351438540',
  appId: '1:572351438540:web:fa4cd2b00faf9602800c69',
  measurementId: 'G-9Z210V708B'
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(async (payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  console.log('[firebase-messaging-sw.js] Notification payload:', payload.notification);
  console.log('[firebase-messaging-sw.js] Data payload:', payload.data);
  
  try {
    const notificationTitle = payload.notification?.title || 'The Mob State';
    const notificationOptions = {
      body: payload.notification?.body || 'You have a new notification',
      icon: './icons/Icon-192.png',
      badge: './icons/Icon-192.png',
      tag: payload.data?.id || payload.notification?.title || 'notification',
      data: payload.data,
      requireInteraction: true,
      timestamp: Date.now(),
      vibrate: [200, 100, 200],
      silent: false
    };

    console.log('[firebase-messaging-sw.js] Showing notification:', notificationTitle, notificationOptions);
    // Use tag for deduplication - same tag won't show twice
    await self.registration.showNotification(notificationTitle, notificationOptions);
    console.log('[firebase-messaging-sw.js] ✅ Notification shown successfully');
  } catch (error) {
    console.error('[firebase-messaging-sw.js] ❌ Error showing notification:', error);
    console.error('[firebase-messaging-sw.js] Error details:', error.message, error.stack);
  }
});

// Handle notification clicks
self.addEventListener('notificationclick', (event) => {
  console.log('[firebase-messaging-sw.js] Notification clicked:', event);
  event.notification.close();

  // Open the app or focus existing window
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((clientList) => {
      // Check if there's already a window open
      for (const client of clientList) {
        if (client.url.includes(self.registration.scope) && 'focus' in client) {
          return client.focus();
        }
      }
      // If no window is open, open a new one
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    })
  );
});
