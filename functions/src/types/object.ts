import { Kind } from "./enum";
import { IBase, Timestamp } from "./def";

interface IHashtag extends IBase {
    counts: number;
    scores: number;
    banned: boolean;
    last_used_at: Timestamp;
}

interface ICount extends IBase {
    counts: number;
}

interface IReaction extends IBase {
    type: Kind;
    tid: string;
    removed: boolean;
}

interface IMention extends IBase {
    url: string;
    uname: string;
    verified: boolean;
}

interface IMedia {
    url: string;
    path: string;
    type: string;
    others: string[];
}

export { IHashtag, ICount, IReaction, IMedia, IMention, Timestamp };
