import Configure from "./services/firebase-service";
import WriterController from "./controllers/writer-controller";
import FeedController from "./controllers/feed-controller";

/// Initialize services
Configure.init();
const author = new WriterController();
const feed = new FeedController();

///Define variables to export
const onFollow = author.onFollow();
const onUser = author.onUser();

const onPost = feed.onPost();
const onReply = feed.onReply();
const onToggle = feed.onToggle();

///Export mothods to be used as cloud functions
export { onFollow, onUser, onPost, onReply, onToggle };
