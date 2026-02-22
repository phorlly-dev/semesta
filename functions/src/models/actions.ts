import { Timestamp } from "firebase-admin/firestore";
import { IModel } from "../types/def";
import { Kind } from "../types/enum";
import { TData } from "../types/type";
import { IMention, IReaction } from "../types/object";

class Reaction implements IModel<IReaction> {
    private _data: IReaction;

    constructor(data: TData) {
        this._data = this.transform$(data);
    }

    public get state() {
        return this._data;
    }

    public set payload(data: TData) {
        this._data = this.transform$(data);
    }

    protected transform$ = (data: TData): IReaction => {
        return {
            id: data.id ?? "",
            tid: data.tid ?? "",
            type: data.type ?? Kind.following,
            removed: data.removed ?? false,
            created_at: Timestamp.now(),
        };
    };
}

class Mention implements IModel<IMention> {
    private _data: IMention;

    constructor(data: TData) {
        this._data = this.transform$(data);
    }

    public get state() {
        return this._data;
    }

    public set payload(data: TData) {
        this._data = this.transform$(data);
    }

    protected transform$ = (data: TData): IMention => {
        return {
            id: data.id ?? "",
            url: data.url ?? "",
            name: data.name ?? "",
            uname: data.uname ?? "",
            updated_at: Timestamp.now(),
            verified: data.verified ?? false,
            created_at: data.created_at ?? Timestamp.now(),
        };
    };
}

export { Reaction, Mention };
