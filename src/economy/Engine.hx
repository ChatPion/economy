package economy;

import economy.Family.FamilyBuilder;

class Engine {
    public var spaces(default, null): Map<Int, Space>;
    public function new() {
        spaces = [];
    }

    public function add(space: Space, id: Int) {
        spaces[id] = space;
    }

    public function remove(id: Int) {
        spaces.remove(id);
    }

    public function get(id: Int) {
        return spaces[id];
    }

    /**
     * Update all spaces of the engine. The order is unknown.
     * @param delta 
     */
    public function update(delta: Float) {
        for (_ => space in spaces)
            space.update(delta);
    }

}