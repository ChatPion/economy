package ecs;

import ecs.utils.ImmutableList;

class EntityFamily extends ImmutableList<Entity> {

    public var family(default, null): Family;
    public var length(get, null): Int;

    public function new(list: List<Entity>, ?family: Family) {
        super(list);

        if (family == null)
            family = Family.all([]).get();
        this.family = family;
    }

    public function get_length(): Int {
        return this.list.length;
    }
}