import { HttpsError } from "firebase-functions/https";
import { Hashtag, DailyCount } from "../models/stats";
import ICachedService from "../services/cached-service";
import { Kind, Path, Stats, Table } from "../types/enum";
import { TBatch, TData } from "../types/type";
import { IMedia } from "../types/object";
import { IProps } from "../types/def";
import { Reaction } from "../models/actions";

class FeedRepository extends ICachedService {
    public get setPost() {
        return this.action$(Path.post, this._handler);
    }

    public get setReply() {
        return this.action$(Path.reply, this._handler);
    }

    public get setToggle() {
        return this.ask$(async (auth, data) => {
            const uid = auth?.uid;
            const params: TData = data?.props;

            if (!uid) throw new HttpsError("unauthenticated", "Login required");
            if (!params) throw new HttpsError("invalid-argument", "Invalid data provided for toggling reaction.");

            switch (params.name) {
                case Stats.save:
                    return this._toggSave({ ...params, uid });

                case Stats.repost:
                    return this._toggleRepost({ ...params, uid });

                default:
                    return this._toggleLike({ ...params, uid });
            }
        });
    }

    private _handler: IProps = {
        onCreated: async (data) => {
            await this.submit$(async (run) => {
                await Promise.all([this._hashtags(run, data), this._stats(run, data)]);
                await run.commit();
            });
        },
        onChanged: async (_before, _after) => {},
        onCleared: async (data) => {
            await this._media(data);
            await this.submit$(async (run) => {
                await this._stats(run, data, true);
                await run.commit();
            });
        },
    };

    private _stats = async (run: TBatch, data: TData, inactive = false) => {
        if (!data) throw new HttpsError("not-found", "No data found in the post");

        const id: string = data.pid;
        if (id) {
            const type: string = data.type;
            const ref = this.col$(Table.post).doc(id);
            if (type === Kind.quote) run.update(ref, { "stats.quotes": inactive ? this.sub$ : this.add$ });
            else if (type === Kind.reply) run.update(ref, { "stats.replies": inactive ? this.sub$ : this.add$ });
        }

        return;
    };

    private _hashtags = async (run: TBatch, data: TData) => {
        const hashtags: string[] = data?.hashtags ?? [];
        if (!hashtags.length) throw new HttpsError("not-found", "No hashtags found in the post");

        for (const name of new Set(hashtags)) {
            /// Prepare references for hashtag and daily count documents
            const id = name.toLowerCase();
            const ref = this.col$(Table.tag).doc(id);
            const col = ref.collection(Table.count);
            const sref = col.doc(this.today$);

            // Fetch both documents in parallel
            const [res, sres, query] = await Promise.all([
                ref.get(),
                sref.get(),
                col.orderBy(this.did$, "desc").where(this.did$, ">=", this.ago$).get(),
            ]);

            /// Extract data from documents
            const tag = res.exists ? res.data() : null;
            const daily = sres.exists ? sres.data() : null;

            // Calculate recent total and score
            let total = 0;
            query.forEach((doc) => {
                total += doc.data()?.counts ?? 0;
            });

            /// Calculate new score and update both documents
            const scores: number = total * 3 + (tag?.counts ?? 0) * 0.2;
            run.set(ref, new Hashtag({ ...tag, id, name, scores, counts: this.add$ }).state, { merge: true });
            run.set(sref, new DailyCount({ ...daily, id: this.today$, counts: this.add$ }).state, { merge: true });
        }
    };

    private _media = async (data: TData) => {
        const media: IMedia[] = data?.media ?? [];
        if (!media) throw new HttpsError("not-found", "No media found in the post");

        media.forEach(async (value) => {
            await this.clearElse$(value?.path);
            await this.clearElse$(value?.others[1]);
        });
    };

    private _toggleLike = (data: TData) => {
        const { id, pid, uid, name } = data;
        const _ref = this.col$(Table.post);

        return this.execute$(async (run) => {
            // Determine the reference path based on whether this is a reply or post
            const postRef = pid ? _ref.doc(pid).collection(Table.reply).doc(id) : _ref.doc(id);
            const reactionRef = postRef.collection(name).doc(uid);

            // Verify post exists
            const postSnapshot = await run.get(postRef);
            if (!postSnapshot.exists) {
                throw new HttpsError("not-found", "No post found for the given ID");
            }

            // Check if reaction already exists
            const reactionSnapshot = await run.get(reactionRef);
            if (reactionSnapshot.exists) {
                // Remove reaction & decrement stats
                run.delete(reactionRef);
                run.update(postRef, { "stats.likes": this.sub$ });

                return { liking: false };
            } else {
                // Add reaction & increment stats
                const reaction = new Reaction({ id, tid: uid, type: Kind.like }).state;
                run.set(reactionRef, reaction);
                run.update(postRef, { "stats.likes": this.add$ });

                return { liking: true };
            }
        });
    };

    private _toggleRepost = (data: TData) => {
        const { id, pid, uid, name } = data;
        const _ref = this.col$(Table.post);

        return this.execute$(async (run) => {
            // Determine the reference path based on whether this is a reply or post
            const postRef = pid ? _ref.doc(pid).collection(Table.reply).doc(id) : _ref.doc(id);
            const reactionRef = postRef.collection(name).doc(uid);

            // Verify post exists
            const postSnapshot = await run.get(postRef);
            if (!postSnapshot.exists) {
                throw new HttpsError("not-found", "No post found for the given ID");
            }

            // Check if reaction already exists
            const reactionSnapshot = await run.get(reactionRef);
            if (reactionSnapshot.exists) {
                // Remove reaction & decrement stats
                run.delete(reactionRef);
                run.update(postRef, { "stats.reposts": this.sub$ });

                return { reposting: false };
            } else {
                // Add reaction & increment stats
                const reaction = new Reaction({ id, tid: uid, type: Kind.repost }).state;
                run.set(reactionRef, reaction);
                run.update(postRef, { "stats.reposts": this.add$ });

                return { reposting: true };
            }
        });
    };

    private _toggSave = (data: TData) => {
        const { id, pid, uid, name } = data;
        const _ref = this.col$(Table.post);

        return this.execute$(async (run) => {
            // Determine the reference path based on whether this is a reply or post
            const postRef = pid ? _ref.doc(pid).collection(Table.reply).doc(id) : _ref.doc(id);
            const reactionRef = postRef.collection(name).doc(uid);

            // Verify post exists
            const postSnapshot = await run.get(postRef);
            if (!postSnapshot.exists) {
                throw new HttpsError("not-found", "No post found for the given ID");
            }

            // Check if reaction already exists
            const reactionSnapshot = await run.get(reactionRef);
            if (reactionSnapshot.exists) {
                // Remove reaction & decrement stats
                run.delete(reactionRef);
                run.update(postRef, { "stats.saves": this.sub$ });

                return { saving: true };
            } else {
                // Add reaction & increment stats
                const reaction = new Reaction({ id, tid: uid, type: Kind.save }).state;
                run.set(reactionRef, reaction);
                run.update(postRef, { "stats.saves": this.add$ });

                return { saving: true };
            }
        });
    };
}

export default FeedRepository;
