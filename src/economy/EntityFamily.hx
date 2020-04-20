package economy;

import economy.utils.ImmutableList;

class EntityFamily extends ImmutableList<Entity> {

    public var length(get, null): Int;

    public function new(list: List<Entity>) {
        super(list);
    }

    public function get_length(): Int {
        return this.list.length;
    }
}