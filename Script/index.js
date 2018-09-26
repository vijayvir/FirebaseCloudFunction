
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//https://firebase.googleblog.com/2016/01/keeping-our-promises-and-callbacks_76.html

'use strict';

const functions = require('firebase-functions');
 const admin = require('firebase-admin');
 admin.initializeApp();
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
 console.log('Fetched follower change', request);
});
/**
 * Triggers when a user gets a new follower and sends a notification.
 *
 * Followers add a flag to `/followers/{followedUid}/{followerUid}`.
 * Users save their device notification tokens to `/users/{followedUid}/notificationTokens/{notificationToken}`.
 */
 
    //  console.log('Uppercasing', context);
     //  console.log('snapshot******_data****** :- ', snapshot._data.toID);
//       console.log('snapshot******data****** :- ', snapshot.data);
//
// console.log('snapshot isGrd44444Chat :- ' + original.toID );
      // console.log('snapshot isGrou444444dddddpChat :- ' + original.isGroupChat );
       //const getDeviceTokensPromise = admin.database()
//  .ref(`/users/${toIDUser}/credentials/token`).once('value');
      
   
        
//   console.log('Fetched notification change', context.params.followedUid);
//       console.log('**************', context.params.followedUidd);  


exports.sendNotification = functions.database.ref('/conversations/{chatLocation}/{messageLocation}')
  .onCreate((snapshot, context) => {
      // Grab the current value of what was written to the Realtime Database.
      const original = snapshot.val();

       const toIDUser = original.toID;
       const isGroupChat = original.isGroupChat;
       
      
       if (isGroupChat) {
       
       
       const tokenss =  admin.database().ref(`/users/${toIDUser}/tokens`).once('value').then(function(snapshot) {

       const tokenOfGroup = snapshot.val()
     
       const valuess = Object.keys(tokenOfGroup).map(k => tokenOfGroup[k]);
     
     //console.log(' ____________ddd((999999ddd_________________ ' +  valuess );
    const payload = {
       notification: {
                 title:   original.senderName + " :- ",
                 body:    original.content
    }
  };

  return admin.messaging().sendToDevice(valuess, payload);
  

  
}, function(error) {
 
  console.error(error);
});

       return ;
          } else {
                const tokenss =  admin.database().ref(`/users/${toIDUser}/credentials`).once('value').then(function(snapshot) {
  // The Promise was "fulfilled" (it succeeded).
  
     const credentials = snapshot.val()
     
     
     
    // console.log('snapshot ......snapshot.val().name****^^^^^^^^^^^^kensPromise****** :- ', credentials.name);
     //console.log('snapshot.....****snapshot.val().token****^^^^^^^^^^^^kensPromise****** :- ', credentials.token);
    
    
     const deviceToken = credentials.token;
     
    const payload = {
       notification: {
                 title:   original.senderName + " :- ",
                 body:    original.content
    }
  };

  return admin.messaging().sendToDevice(deviceToken, payload);
  
  
}, function(error) {
 
  console.error(error);
});
      
          
          }
    


       
  
  return ;
       

    });
    
    
     // const uppercase = original.toUpperCase();
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Firebase Realtime Database.
      // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
      //return snapshot.ref.parent.child('uppercase').set(uppercase);

    
  //  .onWrite(async (change, context) => {
//     
           // console.log('Fetched notification change', context.params.followerUid);/
//            console.log('Fetched follower profile', context);
//  //      const followerUid = context.params.followerUid;
// //       const followedUid = context.params.followedUid;
// //       // If un-follow we exit the function.
// //       if (!change.after.val()) {
// //         return console.log('User ', followerUid, 'un-followed user', followedUid);
// //       }
// //       console.log('We have a new follower UID:', followerUid, 'for user:', followedUid);
// // 
// //       // Get the list of device notification tokens.
// //       const getDeviceTokensPromise = admin.database()
// //           .ref(`/users/${followedUid}/notificationTokens`).once('value');
// // 
// //       // Get the follower profile.
// //       const getFollowerProfilePromise = admin.auth().getUser(followerUid);
// // 
// //       // The snapshot to the user's tokens.
// //       let tokensSnapshot;
// // 
// //       // The array containing all the user's tokens.
// //       let tokens;
// // 
// //       const results = await Promise.all([getDeviceTokensPromise, getFollowerProfilePromise]);
// //       tokensSnapshot = results[0];
// //       const follower = results[1];
// // 
// //       // Check if there are any device tokens.
// //       if (!tokensSnapshot.hasChildren()) {
// //         return console.log('There are no notification tokens to send to.');
// //       }
// //       console.log('There are', tokensSnapshot.numChildren(), 'tokens to send notifications to.');
// //       console.log('Fetched follower profile', follower);
// // 
// //       // Notification details.
// //       const payload = {
// //         notification: {
// //           title: 'You have a new follower!',
// //           body: `${follower.displayName} is now following you.`,
// //           icon: follower.photoURL
// //         }
// //       };
// // 
// //       // Listing all tokens as an array.
// //       tokens = Object.keys(tokensSnapshot.val());
// //       // Send notifications to all tokens.
// //       const response = await admin.messaging().sendToDevice(tokens, payload);
// //       // For each message check if there was an error.
// //       const tokensToRemove = [];
// //       response.results.forEach((result, index) => {
// //         const error = result.error;
// //         if (error) {
// //           console.error('Failure sending notification to', tokens[index], error);
// //           // Cleanup the tokens who are not registered anymore.
// //           if (error.code === 'messaging/invalid-registration-token' ||
// //               error.code === 'messaging/registration-token-not-registered') {
// //             tokensToRemove.push(tokensSnapshot.ref.child(tokens[index]).remove());
// //           }
// //         }
// //       });
// //       return Promise.all(tokensToRemove);
   //  });

