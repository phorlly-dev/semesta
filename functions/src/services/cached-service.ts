import * as exp from "express";
import * as http from "firebase-functions/https";
import IFirebaseService from "./firebase-service";
import { TDoc, TQuery } from "../types/type";
import { AuthData } from "firebase-functions/tasks";
import * as fs from "firebase-functions/v2/firestore";
import { FieldPath, FieldValue } from "firebase-admin/firestore";
import { IProps } from "../types/def";

abstract class ICachedService extends IFirebaseService {
    protected did$ = FieldPath.documentId();
    protected add$ = FieldValue.increment(1);
    protected sub$ = FieldValue.increment(-1);
    protected today$ = new Date().toLocaleDateString("en-CA");

    protected ago$ = (day: number = 3) => {
        const now = new Date();
        const time_ago = new Date(now);
        time_ago.setDate(time_ago.getDate() - day);

        return time_ago.toLocaleDateString("en-CA");
    };

    protected clearIf$ = async (oldValue?: string, newValue?: string) => {
        if (oldValue && oldValue !== newValue) await this.clearCache$(oldValue);
        return;
    };

    protected clearElse$ = async (value?: string) => {
        if (value) await this.clearCache$(value);
        return;
    };

    protected ask$ = <T = any>(fn: (auth?: AuthData, data?: any) => Promise<T>) => {
        return http.onCall((req) => fn(req.auth, req.data));
    };

    protected send$ = (fn: (req: exp.Request, res: exp.Response) => Promise<void>) => {
        return http.onRequest(fn);
    };

    protected stored$ = <T extends string>(path: T, fn: (query?: TQuery) => Promise<any>) => {
        return fs.onDocumentCreated(path, (event) => fn(event.data));
    };

    protected changed$ = <T extends string>(path: T, fn: (before?: TQuery, after?: TQuery) => Promise<any>) => {
        return fs.onDocumentUpdated(path, (event) => {
            const data = event.data;
            return fn(data?.before, data?.after);
        });
    };

    protected removed$ = <T extends string>(path: T, fn: (query?: TQuery) => Promise<any>) => {
        return fs.onDocumentDeleted(path, (event) => fn(event.data));
    };

    protected cud$ = <T extends string>(path: T, fn: (before?: TDoc, after?: TDoc) => Promise<any>) => {
        return fs.onDocumentWritten(path, (event) => {
            const data = event.data;
            return fn(data?.before, data?.after);
        });
    };

    protected action$ = (path: string, fn: IProps) => {
        return fs.onDocumentWritten(path, (event) => {
            const _data = event.data;
            const before = _data?.before.data();
            const after = _data?.after.data();

            // CREATED
            if (!before && after) {
                return fn.onCreated(after);
            }

            // UPDATED
            else if (before && after) {
                return fn.onChanged(before, after);
            }

            // DELETED
            else if (before && !after) {
                return fn.onCleared(before);
            }

            return;
        });
    };
}

export default ICachedService;
