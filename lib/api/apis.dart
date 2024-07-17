import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/messenger/messages.dart';
import 'package:whisper/models/chat_messages.dart';
import 'package:whisper/models/chat_user_model.dart';
import 'package:whisper/models/pin_messages.dart';
import 'package:whisper/models/word_effect_models.dart';

import '../models/chat_emoji_theme.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get users => auth.currentUser!;

  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static  late ChatUserModel userData;

  static Future<bool> userExists() async {
    return (await FirebaseFirestore.instance
            .collection('users')
            .doc(users.uid)
            .get())
        .exists;
  }

  static Future<void> getselfInfo() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(users.uid)
        .get()
        .then(
      (users) async {
        if (users.exists) {
          userData = ChatUserModel.fromJson(users.data()!);
          await getFirebaseMessaging();
          updateActiveStatus(true);
        } else {
          await createUser().then(
            (value) => getselfInfo(),
          );
        }
      },
    );
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatuser = ChatUserModel(
      name: auth.currentUser!.displayName.toString(),
      lastMessage: 'Hello there how are you',
      image: users.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      id: users.uid,
      lastActive: time,
      email: users.email.toString(),
      pushToken: users.phoneNumber.toString(),
      block: false,
    );

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(users.uid)
        .set(chatuser.toJson()).then((onValue)=> print('user created successfully'));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUnBlockUsers(List<String> userIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('block', isEqualTo: false)
        .snapshots();
  }

  static Future<void> blockUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'blocked': true});
  }

  static Future<void> unblockUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'blocked': false});
  }

  static Future<void> updateUserInfo() async {
    await FirebaseFirestore.instance.collection('users').doc(users.uid).update({
      'name': userData.name,
      'email': userData.email,
      'last_message': userData.lastMessage,
      'push_token': userData.pushToken,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    final extension = file.path.split('.').last;
    final ref = storage.ref().child('profile_picture/${users.uid}.$extension');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$extension'));
    userData.image = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(users.uid).update({
      'image': userData.image,
    });
  }

  static conversationID(String id) => users.uid.hashCode <= id.hashCode
      ? '${users.uid}_${id}'
      : '${id}_${users.uid}';
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUserModel user) {
    return FirebaseFirestore.instance
        .collection('chats/${conversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessages(ChatUserModel chatUser, String message, Type type) async {
    // Generate the current timestamp
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // Reference to the collection
      final ref = FirebaseFirestore.instance
          .collection('chats/${conversationID(chatUser.id)}/messages');

      // Create a new document reference with an auto-generated ID
      final docRef = ref.doc();

      // Create a MessagesModel object
      final MessagesModel messages = MessagesModel(
        docid: docRef.id, // Use the auto-generated document ID
        toid: chatUser.id,
        fromid: users.uid,
        msg: message,
        read: '',
        sent: time,
        type: type, // Ensure this matches your enum definition
      );

      // Add the document with the data including the document ID
      await docRef.set(messages.toJson());

      // Verify the stored document
      DocumentSnapshot document = await docRef.get();
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Assuming you have a function to get the conversation ID

  static Future<void> updateMessageStatus(MessagesModel message) async {
    FirebaseFirestore.instance
        .collection('chats/${conversationID(message.fromid)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUserModel user) {
    return FirebaseFirestore.instance
        .collection('chats/${conversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> SendImageToChat(ChatUserModel chatuser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${conversationID(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext'));
    final imagemessageURL = await ref.getDownloadURL();
    await sendMessages(chatuser, imagemessageURL, Type.image);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUserModel chatuser) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: chatuser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    FirebaseFirestore.instance.collection('users').doc(users.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      "push_token": userData.pushToken,
    });
  }

  static Future<void> getFirebaseMessaging() async {
    await messaging.requestPermission();
    await messaging.getToken().then((token) {
      if (token != null) {
        userData.pushToken = token;
        print("push Token: $token");
      }
    });
  }
  static Future<void> deleteMessage(MessagesModel message) async {
    await FirebaseFirestore.instance
        .collection('chats/${conversationID(message.toid)}/messages/')
        .doc(message.docid)
        .delete();

    if (message.type == Type.image) {
      await FirebaseStorage.instance.refFromURL(message.msg).delete();
    }
  }

  static Future<void> UpdateMessage(MessagesModel message, String updatedMessage) async {
    await FirebaseFirestore.instance
        .collection('chats/${conversationID(message.toid)}/messages/')
        .doc(message.docid)
        .update({'msg': updatedMessage});
  }

  static Future<bool> addChatUser(String email) async {
    print("data: ${users}");
    final data = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    print('data is:  $data');
    if (data.docs.isNotEmpty) {
      print("Inside If condition ");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(users.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({}).then((onValue) => print('Successfully Added'));

      return true;
    } else {
      return false;
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUserId() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(users.uid)
        .collection('my_users')
        .snapshots();
  }

  static Future<void> sendmessageToNewUserFirstTime(ChatUserModel chatUser, String message, Type type) async {
    // Adding the new user
    await FirebaseFirestore.instance
        .collection('users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(users.uid)
        .set({}).then((value) => sendMessages(chatUser, message, type));
  }

  static Future getEmoji(ChatUserModel chatUser) async {
    String chatID = conversationID(chatUser.id);
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('chats').doc(chatID).get();
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data?['emoji'];
    }
    return null;
  }

  static Future getTheme(ChatUserModel chatUser) async {String chatID = conversationID(chatUser.id);

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('chats').doc(chatID).get();
    if (doc.exists) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      return data?['theme'];
    }
    return null;
  }

  static Future<void> setEmojiTheme(ChatUserModel chatUser, String emoji, String theme) async {
    String chatId = conversationID(chatUser.id);
    final setEmojiTheme =
        ChatEmojiTheme(
            emoji: emoji.isNotEmpty? emoji: '👍',
            theme: theme.isNotEmpty? theme :'assets/defaultTheme.png');
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .set(
          setEmojiTheme.toJson(),
          SetOptions(
              merge:
                  false), // Merge option ensures the document is updated or created
        )
        .then((value) => print("emoji added successfully"))
        .catchError((onError) => print("Error adding emoji: $onError"));
  }

  static Future<void> updateEmoji(ChatUserModel chatUser, String emoji) async {
    String chatId = conversationID(chatUser.id);
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .set(
          {'emoji': emoji},
          SetOptions(
              merge:
                  true), // Merge option ensures the document is updated or created
        )
        .then((value) => print("emoji added successfully"))
        .catchError((onError) => print("Error adding emoji: $onError"));
  }

  static Future<void> updateTheme(ChatUserModel chatUser, String theme) async {
    // Get the chat ID (assuming you have a method to get the chat ID between two users)
    String chatId = conversationID(chatUser.id);

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .set(
          {
            'theme': theme,
          },
          SetOptions(
              merge:
                  true), // Merge option ensures the document is updated or created
        )
        .then((value) => print("Theme added successfully"))
        .catchError((onError) => print("Error adding theme: $onError"));
  }

  static Future<void> deleteChat(ChatUserModel chatUser) async {
    // Get the reference to the 'my_users' subcollection document

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(users.uid);
    final myUsersDocRef = userDocRef.collection('my_users').doc(chatUser.id);

    // Delete the user document from the 'my_users' subcollection
    await myUsersDocRef.delete().then((_) {
      print('User document deleted successfully');
    }).catchError((error) {
      print('Error deleting user document: $error');
    });

    // Delete the chat messages associated with the user
    final messagesCollectionRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(users.uid)
        .collection('messages');
    final messagesSnapshot = await messagesCollectionRef.get();

    for (final messageDoc in messagesSnapshot.docs) {
      await messageDoc.reference.delete().then((_) {
        print('Chat message deleted successfully');
      }).catchError((error) {
        print('Error deleting chat message: $error');
      });
    }
  }

  static Future<void> storeWordEffect(ChatUserModel chatUser, String words, String effects) async {
    String chatId = conversationID(chatUser.id);
    final setWordEffect = WordEffectModels(word: words.isNotEmpty? words: " Hello".toLowerCase(), effect: effects.isNotEmpty? effects: "👋", id: chatId);
    return  FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId).collection('word_effects').add(setWordEffect.toJson())
        .then((value) => print("Word effect  added successfully"))
        .catchError((onError) => print("Error adding word effect: $onError"));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>getWordEfect(ChatUserModel chatUser){
    String chatID = conversationID(chatUser.id);
    return FirebaseFirestore.instance
        .collection('chats').doc(chatID).collection('word_effects')
        .snapshots();

  }

  static Future<void> deleteWordEffect(ChatUserModel chatUser) async {
    String chatId = conversationID(chatUser.id);

    // Reference to the word_effects collection
    var collectionRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('word_effects');

    // Query to find the document with the id equal to chatId
    var querySnapshot = await collectionRef.where('id', isEqualTo: chatId).get();

    // Loop through the documents and delete them
    for (var doc in querySnapshot.docs) {
      await collectionRef.doc(doc.id).delete();
    }
  }

  static Future<List<WordEffectModels>> getAllWordEffects(ChatUserModel chatUser) async {

    String chatId = conversationID(chatUser.id);
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('chats').doc(chatId).collection('word_effects').get();

    return snapshot.docs
        .map((doc) => WordEffectModels.fromJson(doc.data()))
        .toList();
  }

  static Future<void> pinMessage(String chatUser,String message)async{
    final times = DateTime.now().millisecondsSinceEpoch.toString();
    final pinMessages = PinMessagesModels(message: message, time: times);
    String chatId = conversationID(chatUser);
try {
  await FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId).collection('pin_messages').add(pinMessages.toJson()).then((
      onValue) => print('added messaged to pinned'));
}catch(e){
  print('error is: $e');
}
}


  static Future<List<PinMessagesModels>> getPinMessages(String chatUser) async {
    String chatId = conversationID(chatUser);

    // Fetch the documents from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('pin_messages')
        .get();

    // Map the documents to a list of PinMessage objects
    List<PinMessagesModels> pinMessages = snapshot.docs.map((doc) {
      return PinMessagesModels(
        message: doc['message'] as String,
        time: doc['time'] as String,
      );
    }).toList();

    return pinMessages;
  }

  static Future<List<String>> getMediaImages(ChatUserModel chatUser) async {
    String chatId = conversationID(chatUser.id);
    List<String> imageUrls = [];

    // Reference to the chat folder in Firebase Storage
    Reference storageRef = FirebaseStorage.instance.ref('images/$chatId');

    try {
      // List all items in the folder
      final ListResult result = await storageRef.listAll();

      // Loop through each item and get the download URL
      for (var item in result.items) {
        String url = await item.getDownloadURL();
        imageUrls.add(url); // Store the URL
      }
    } catch (e) {
      print('Error retrieving images: $e');
    }

    return imageUrls; // Return the list of URLs
  }
}
