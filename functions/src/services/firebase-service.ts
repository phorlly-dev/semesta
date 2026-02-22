import { TBatch } from "../types/type";
import { initializeApp } from "firebase-admin/app";
import { setGlobalOptions } from "firebase-functions";
import { getFirestore, Transaction } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";

abstract class IFirebaseService {
    public db = getFirestore();
    public cache = getStorage();
    public static init() {
        initializeApp();
        setGlobalOptions({ maxInstances: 10 });
        getFirestore().settings({ ignoreUndefinedProperties: true });
    }

    protected clearCache$ = (path: string) => {
        return this.cache.bucket().file(path).delete();
    };

    protected col$ = (path: string) => {
        return this.db.collection(path);
    };

    protected doc$ = (path: string) => {
        return this.db.doc(path);
    };

    protected subcol$ = (name: string) => {
        return this.db.collectionGroup(name);
    };

    protected submit$ = (fn: (run: TBatch) => Promise<void>) => {
        return fn(this.db.batch());
    };

    public execute$ = <T>(fn: (run: Transaction) => Promise<T>) => {
        return this.db.runTransaction<T>(fn);
    };
}

export default IFirebaseService;
