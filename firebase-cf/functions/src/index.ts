import * as admin from 'firebase-admin';
import onUserCreate from './auth/onUserCreate';
import onTaskCreated from './firestore/onTaskCreated';
import onTaskDeleted from './firestore/onTaskDeleted';

admin.initializeApp();

export { onUserCreate, onTaskCreated, onTaskDeleted };
