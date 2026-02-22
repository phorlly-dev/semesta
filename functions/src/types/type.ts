import { DocumentData, Firestore, WriteBatch } from "firebase-admin/firestore";
import { DocumentSnapshot, QueryDocumentSnapshot } from "firebase-functions/v2/firestore";

type TData = DocumentData;
type TStore = Firestore;
type TBatch = WriteBatch;
type TDoc = DocumentSnapshot;
type TQuery = QueryDocumentSnapshot;

export { TData, TDoc, TQuery, TStore, TBatch };
