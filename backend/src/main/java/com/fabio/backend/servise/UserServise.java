package com.fabio.backend.servise;

import com.fabio.backend.model.User;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ExecutionException;

@Service
public class UserServise {

    private static final String COLLECTION_NAME = "pessoa";

    public String saveUser(User user) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        CollectionReference collectionReference = dbFirestore.collection(COLLECTION_NAME);

        DocumentReference newDocumentReference = collectionReference.document();
        String novoId = newDocumentReference.getId();

        user.setId(novoId);
        ApiFuture<WriteResult> collectionAPIFuture = newDocumentReference.set(user);

        return collectionAPIFuture.get().getUpdateTime().toString();
    }

    public User getUserID(String id) throws ExecutionException, InterruptedException {
        User user = null;
        Firestore dbFirestore = FirestoreClient.getFirestore();
        DocumentReference documentReference = dbFirestore.collection(COLLECTION_NAME).document(id);
        ApiFuture<DocumentSnapshot> future = documentReference.get();
        DocumentSnapshot document = future.get();

        if(document.exists()){
            user = document.toObject(User.class);
            return user;
        }else{
            return null;
        }

    }

    public List<User> getUser() throws ExecutionException, InterruptedException {
        User user = null;
        List<User> listUsers = new ArrayList<User>();
        Firestore dbFirestore = FirestoreClient.getFirestore();
        Iterable<DocumentReference> documentReference = dbFirestore.collection(COLLECTION_NAME).listDocuments();
        Iterator<DocumentReference> iterator = documentReference.iterator();
        while(iterator.hasNext()) {
            DocumentReference documentReference1= iterator.next();
            ApiFuture<DocumentSnapshot> future = documentReference1.get();
            DocumentSnapshot document = future.get();
            user = document.toObject(User.class);
            listUsers.add(user);
        }
        return listUsers;
    }

    public String updateUser(String id,User user) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> collectionAPIFuture = dbFirestore.collection(COLLECTION_NAME).document(id).set(user);
        return collectionAPIFuture.get().getUpdateTime().toString();
    }

    public String deleteUser(String id) throws ExecutionException, InterruptedException {
        Firestore dbFirestore = FirestoreClient.getFirestore();
        ApiFuture<WriteResult> collectionAPIFuture = dbFirestore.collection(COLLECTION_NAME).document(id).delete();
        return collectionAPIFuture.get().getUpdateTime().toString();
    }
}
