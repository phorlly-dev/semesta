enum Kind {
    post = "post",
    like = "like",
    save = "save",
    media = "media",
    view = "view",
    share = "share",
    quote = "quote",
    reply = "reply",
    repost = "repost",
    following = "following",
    follower = "follower",
}

enum Stats {
    post = "posts",
    like = "likes",
    save = "saves",
    media = "media",
    view = "views",
    share = "shares",
    quote = "quotes",
    reply = "replies",
    repost = "reposts",
}

enum Table {
    user = "users",
    post = Stats.post,
    reply = Stats.reply,
    tag = "hashtags",
    mention = "mentions",
    count = "daily_counts",
}

enum Path {
    post = `${Table.post}/{id}`,
    user = `${Table.user}/{id}`,
    reply = `${Table.post}/{pid}/${Table.reply}/{cid}`,
}

export { Table, Path, Kind, Stats };
