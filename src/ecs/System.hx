package ecs;

import ecs.Process;

interface SystemListener {
    public function addedToSpace(space: Space): Void;
    public function removedFromSpace(space: Space): Void;
}

interface System extends Process extends SystemListener {

}

