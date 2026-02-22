import { TData } from "./type";
import { Timestamp } from "firebase-admin/firestore";

interface IBase {
    id: string;
    name?: string;
    created_at: Timestamp;
    updated_at?: Timestamp;
    deleted_at?: Timestamp;
}

// Change this in your helpers file:
interface IModel<T extends TData> {
    readonly state: T; // Getter
    payload: any; // Setter
}

interface IProps {
    onCreated: (data: TData) => Promise<void>;
    onChanged: (before: TData, after: TData) => Promise<void>;
    onCleared: (data: TData) => Promise<void>;
}

export { IBase, IModel, IProps, Timestamp };
