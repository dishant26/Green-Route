const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

var msgData;
var childNode;

// exports.ambulanceNotifier = functions.firestore.document(
//     "Active_Ambulance/{ambulancdID}"
// ).onCreate((snapshot, context) => {
//     msgData = snapshot.data();
	
// 	childNode = msgData.Child_Nodes;

//     admin.firestore().collection("User_Token").get().then((snapshots) => {
//         var tokens = [];
		
//         if (snapshots.empty) {
//             console.log("No Devices");
//         } else {
// 			console.log("Going In!!");
// 			// console.log(childNode[0]);
			
//             for (var token of snapshots.docs) {
				
// 				temp_uid = token.id;
// 				console.log(temp_uid);
// 				for (var nodeUID of childNode) {
// 					// console.log(temp_uid);
// 					console.log(nodeUID);
	
// 					if (nodeUID==temp_uid){ 
// 						tokens.push(token.data().Token_Value);
// 						console.log("Matched!!!");
// 					}	
// 										// else{
// 										// 	// console.log("Not working");
// 										// 	// console.log(temp_uid);
// 										// }					
// 				}	
//             }
// 			var message = {
// 				notification:{title:"Ambulance!",
// 				body:"An Ambulance is coming your way.Please clear the path"},
// 				data: {
// 				  score: '850',
// 				  time: '2:45'
// 				},
// 				tokens: tokens,	
// 			  };

// 			admin.messaging().sendMulticast(message)
//   .then((response) => {
//     // Response is a message ID string.
//     console.log('Successfully sent message:', response);
//   })
//   .catch((error) => {
//     console.log('Error sending message:', error);
//   });
//         }
//     });
// 	return null;
// });




exports.ambulanceNotifier = functions.firestore.document(
    "Active_Ambulance/{ambulancdID}"
).onWrite((change,context) => {
	// console.log("this");
    msgData = change.after.data();
	// console.log(msgData.Ambulance_Latitude);
	childNode = msgData.Child_Nodes;

    admin.firestore().collection("User_Token").get().then((snapshots) => {
        var tokens = [];
		
        if (snapshots.empty) {
            console.log("No Devices");
        } else {
			console.log("Going In!!");
			// console.log(childNode[0]);
			
            for (var token of snapshots.docs) {
				
				temp_uid = token.id;
				// console.log(temp_uid);
				for (var nodeUID of childNode) {
					// console.log(temp_uid);
					// console.log(nodeUID);
	
					if (nodeUID==temp_uid){ 
						tokens.push(token.data().Token_Value);
						console.log("Matched!!!");
					}					
				}	
            }

        }
    },

	admin.firestore().collection("User_Database").get().then((snapshots) =>{
		var newTokens = [];
		if (snapshots.empty) {
			console.log("No Devices");
		} 
		else {
			amb_latitude = msgData.Ambulance_Latitude;
			amb_longitude = msgData.Ambulance_Longitude;

			for (var nodeUID of childNode) {

				for (var token of snapshots.docs)
				{
					temp_uid = token.id;
					if (nodeUID==temp_uid){
						user_lat = token.data().Current_Latitude;
						user_long = token.data().Current_Longitude;
						
						
						a= Math.abs(user_lat - amb_latitude);
						b= Math.abs(user_long - amb_longitude);

						dist = Math.sqrt((a*a)+(b*b));
						// console.log("DIstance is");
						// console.log(dist);
						if (dist <= 0.01) {

							admin.firestore().collection("User_Token").doc(temp_uid).get().then((snapshots) => {
								newMessage = snapshots.data();
								newTokens.push(newMessage.Token_Value);
							})
						}
					}
				}
				
			}
			var message = {
				notification:{title:"Ambulance!",
				body:"An Ambulance is coming your way.Please clear the path"},
				data: {
				  score: '850',
				  time: '2:45'
				},
				tokens: newTokens,	
			  };

			admin.messaging().sendMulticast(message)
			.then((response) => {
				// Response is a message ID string.
				console.log('Successfully sent message:', response);
			})
			.catch((error) => {
				console.log('Error sending message:', error);
			});	
		}

	})
	
	);
	return null;
});