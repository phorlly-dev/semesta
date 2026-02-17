// const {onRequest} = require("firebase-functions/https");
// const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();
const fn = functions.firestore;

const onPostCreated = fn.onDocumentCreated("posts/{id}", _handleHashtags);
const onPostReplyCreated = fn.onDocumentCreated("posts/{pid}/replies/{cid}", _handleHashtags);

const _handleHashtags = async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const hashtags = data.hashtags || [];
    if (!hashtags.length) return;

    const batch = db.batch();
    await _onAfterPostCreated(batch, hashtags);
    await batch.commit();
};

const _onAfterPostCreated = async (batch, hashtags) => {
    const fields = admin.firestore.FieldValue;
    const add = fields.increment(1);
    const now = fields.serverTimestamp();
    const today = new Date().toISOString().split("T")[0];

    for (const name of new Set(hashtags)) {
        const id = name.toLowerCase();
        const ref = db.collection("hashtags").doc(id);
        const col = ref.collection("daily_counts");
        const daily_ref = col.doc(today);

        batch.set(
            ref,
            {
                id,
                name,
                counts: add,
                banned: false,
                last_used_at: now,
                created_at: now,
            },
            { merge: true },
        );
        batch.set(
            daily_ref,
            {
                id: today,
                counts: add,
                created_at: now,
            },
            { merge: true },
        );
    }
};

module.exports = { onPostCreated, onPostReplyCreated };
functions.setGlobalOptions({ maxInstances: 10 });
