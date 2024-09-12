import * as admin from 'firebase-admin';
import { auth } from 'firebase-functions/v1';

const onUserCreate = auth.user().onCreate(async (user) => {
  const { uid, email } = user;
  const db = admin.firestore();
  const userRef = db.collection('users').doc(uid);
  await userRef.set({
    id: uid,
    email,
    numberOfTasks: 0,
  });
});

export default onUserCreate;
