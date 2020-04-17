package economy;

import economy.utils.Process;

interface SystemListener {
    public function addedToSpace(space: Space): Void;
    public function removedFromSpace(space: Space): Void;
}

class System extends Process implements SystemListener {

    public var space(default, null): Space = null;

    public function addedToSpace(space: Space) {
        this.space = space;
    }

    public function removedFromSpace(space: Space) {
        this.space = null;
    }

}

