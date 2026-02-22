import FeedRepository from "../repositories/feed-repository";

class FeedController {
    private _repo: FeedRepository;

    constructor() {
        this._repo = new FeedRepository();
    }

    public onPost() {
        return this._repo.setPost;
    }

    public onReply() {
        return this._repo.setReply;
    }

    public onToggle() {
        return this._repo.setToggle;
    }
}

export default FeedController;
