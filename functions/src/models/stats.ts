import { IModel, Timestamp } from "../types/def";
import { ICount, IHashtag } from "../types/object";
import { TData } from "../types/type";

class Hashtag implements IModel<IHashtag> {
    private _data: IHashtag;

    constructor(data: TData) {
        // Initializing the backing field
        this._data = this.transform$(data);
    }

    // Matches 'state' in interface
    public get state() {
        return this._data;
    }

    // Matches 'payload' in interface
    public set payload(data: TData) {
        this._data = this.transform$(data);
    }

    protected transform$ = (data: TData): IHashtag => {
        return {
            id: data.id ?? "",
            name: data.name ?? "",
            counts: data.counts ?? 1,
            scores: data.scores ?? 0,
            banned: data.banned ?? false,
            last_used_at: Timestamp.now(),
            created_at: data.created_at ?? Timestamp.now(),
        };
    };
}

class DailyCount implements IModel<ICount> {
    private _data: ICount;

    constructor(data: TData) {
        this._data = this.transform$(data);
    }

    public get state() {
        return this._data;
    }

    public set payload(data: TData) {
        this._data = this.transform$(data);
    }

    protected transform$ = (data: TData): ICount => {
        return {
            id: data.id ?? "",
            counts: data.counts ?? 1,
            created_at: data.created_at ?? Timestamp.now(),
        };
    };
}

export { Hashtag, DailyCount };
