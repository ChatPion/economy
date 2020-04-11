package ecs;

import ecs.Component;

class Entity {

    private var components: Map<String, Component>;

    public function new() {
        this.components = [];
    }

    public function add(component: Component) {
        this.components.set(Type.getClassName(Type.getClass(component)), component);
    }

    public function has(componentClass: Class<Component>) : Bool {
        return this.components.exists(Type.getClassName(componentClass));
    }

    public function get<T:Component>(componentClass: Class<T>) : Null<T> {
        return cast components.get(Type.getClassName(componentClass));
    }

    public function remove(componentClass: Class<Component>) {
        components.remove(Type.getClassName(componentClass));
    }

    public function removeAll() {
        components.clear();
    }

}