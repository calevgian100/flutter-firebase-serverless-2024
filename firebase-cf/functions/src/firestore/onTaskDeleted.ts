import * as admin from 'firebase-admin';
import { firestore } from 'firebase-functions/v1';

const onTaskCreated = firestore
  .document('tasks/{taskId}')
  .onDelete(async (snapshot) => {
    const { user_id } = snapshot.data();
    const db = admin.firestore();
    const userRef = db.collection('users').doc(user_id);
    await userRef.update({
      numberOfTasks: admin.firestore.FieldValue.increment(-1),
    });
  });

export default onTaskCreated;
