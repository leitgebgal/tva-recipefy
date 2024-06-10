import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipefy/models/recipe.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print("Successfully registered user: ${user?.email}");
      return user;
    } catch (e) {
      print("Error registering user: $e");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      print("Successfully signed in user: ${user?.email}");
      return user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      print("Attempting to sign out");
      await _auth.signOut();
      print("Successfully signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  // Add document to Firestore
  Future<void> addDocument(String collection, Map<String, dynamic> data) async {
    try {
      print("Adding data to $collection: $data");
      await _firestore.collection(collection).add(data);
      print("Successfully added data to $collection");
    } catch (e) {
      print("Error adding data to $collection: $e");
    }
  }

  // Read collection from Firestore
  Stream<QuerySnapshot> getCollection(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  // Get single document by ID
  Future<DocumentSnapshot> getDocument(String collection, String docId) async {
    try {
      DocumentSnapshot document = await _firestore.collection(collection).doc(docId).get();
      return document;
    } catch (e) {
      print("Error getting document from $collection/$docId: $e");
      rethrow;
    }
  }

  // Update document in Firestore
  Future<void> updateDocument(String collection, String docId, Map<String, dynamic> data) async {
    try {
      print("Updating data in $collection/$docId: $data");
      await _firestore.collection(collection).doc(docId).update(data);
      print("Successfully updated data in $collection/$docId");
    } catch (e) {
      print("Error updating data in $collection/$docId: $e");
    }
  }

  // Delete document from Firestore
  Future<void> deleteDocument(String collection, String docId) async {
    try {
      print("Deleting data from $collection/$docId");
      await _firestore.collection(collection).doc(docId).delete();
      print("Successfully deleted data from $collection/$docId");
    } catch (e) {
      print("Error deleting data from $collection/$docId: $e");
    }
  }

  // Change user password
  Future<void> changePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        print("Successfully changed password");
      } else {
        print("No user signed in");
      }
    } catch (e) {
      print("Error changing password: $e");
    }
  }

  // Fetch user's recipes
  Future<List<Recipe>> getUserRecipes(String? userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('recipes').where('owner', isEqualTo: userId).get();
      List<Recipe> recipes = querySnapshot.docs.map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>)).toList();
      return recipes;
    } catch (e) {
      print("Error fetching user recipes: $e");
      return [];
    }
  }
}
