package ecs.utils;

class ImmutableList<T> {

    private var list: List<T>;

    public function new(list: List<T>) {
        this.list = list;
    }

    public function iterator(): Iterator<T> {
        return list.iterator();
    }

}