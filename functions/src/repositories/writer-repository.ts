import { HttpsError } from "firebase-functions/https";
import ICachedService from "../services/cached-service";
import { Table, Kind, Path } from "../types/enum";
import { TData } from "../types/type";
import { Mention, Reaction } from "../models/actions";
import Media from "../models/caches";

class WriterRepository extends ICachedService {
    public get setFollow() {
        return this.ask$((auth, data) => {
            const id = auth?.uid;
            const tid: string = data?.target_id;

            if (!id) throw new HttpsError("unauthenticated", "Login required");
            if (!tid || id === tid) throw new HttpsError("invalid-argument", "Invalid target user.");

            return this._follow(id, tid);
        });
    }

    public get setUser() {
        return this.action$(Path.user, {
            onCreated: async (data) => {
                await this._mention(data);
            },
            onChanged: async (before, after) => {
                await Promise.all([this._avatar(before, after), this._mention(after)]);
            },
            onCleared: async (data) => {
                await Promise.all([this._avatar(data), this._mention(data, true)]);
            },
        });
    }

    private _follow = (id: string, tid: string) => {
        const iref = this.col$(Table.user).doc(id);
        const uref = this.col$(Table.user).doc(tid);

        const following_ref = iref.collection(Kind.following).doc(tid);
        const follower_ref = uref.collection(Kind.follower).doc(id);

        return this.execute$(async (run) => {
            const res = await run.get(following_ref);
            if (res.exists) {
                // UNFOLLOW
                run.delete(following_ref);
                run.delete(follower_ref);

                run.update(iref, { following: this.sub$ });
                run.update(uref, { followers: this.sub$ });

                return { following: false };
            } else {
                // FOLLOW
                const data = { id, tid };
                run.set(following_ref, new Reaction({ ...data, type: Kind.following }).state);
                run.set(follower_ref, new Reaction({ ...data, type: Kind.follower }).state);

                run.update(iref, { following: this.add$ });
                run.update(uref, { followers: this.add$ });

                return { following: true };
            }
        });
    };

    private _avatar = async (before: TData, after?: TData) => {
        const old_media = new Media(before?.media ?? {}).state;
        const new_media = new Media(after?.media ?? {}).state;

        if (before && after)
            await Promise.all([
                this.clearIf$(old_media?.path, new_media?.path),
                this.clearIf$(old_media?.others[1], new_media?.others[1]),
            ]);
        else await Promise.all([this.clearElse$(old_media?.path), this.clearElse$(old_media?.others[1])]);
    };

    private _mention = async (data: TData, inactive = false) => {
        if (!data) throw new HttpsError("not-found", "No data found in the user");

        const ref = this.col$(Table.mention).doc(data?.uname.toLocaleLowerCase());
        if (inactive && data) await ref.delete();
        else await ref.set(new Mention({ ...data, url: data?.media?.url }).state, { merge: true });
    };
}

export default WriterRepository;
