import { IModel } from "../types/def";
import { IMedia } from "../types/object";
import { TData } from "../types/type";

class Media implements IModel<IMedia> {
    private _data: IMedia;

    constructor(data: TData) {
        this._data = this.transform$(data);
    }

    public get state() {
        return this._data;
    }

    public set payload(data: TData) {
        this._data = this.transform$(data);
    }

    protected transform$ = (data: TData): IMedia => {
        return {
            url: data.url ?? "",
            path: data.path ?? "",
            type: data.type ?? "image",
            others: data.others ?? [],
        };
    };
}

export default Media;
