import WriterRepository from "../repositories/writer-repository";

class WriterController {
    private _repo: WriterRepository;

    constructor() {
        this._repo = new WriterRepository();
    }

    public onFollow() {
        return this._repo.setFollow;
    }

    public onUser() {
        return this._repo.setUser;
    }
}

export default WriterController;
