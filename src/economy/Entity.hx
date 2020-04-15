package economy;

import economy.Component;

class Entity {

    private var components: Map<String, Component>;
    private var listeners: List<ComponentListener>;

    public function new() {
        this.components = [];
        this.listeners = new List();
    }

    public function add(component: Component) {
        this.components.set(Type.getClassName(Type.getClass(component)), component);
        for (listener in listeners)
            listener.componentAdded(this, component);
    }

    public function has(componentClass: Class<Component>) : Bool {
        return this.components.exists(Type.getClassName(componentClass));
    }

    public function get<T:Component>(componentClass: Class<T>) : Null<T> {
        return cast components.get(Type.getClassName(componentClass));
    }

    public function remove(componentClass: Class<Component>) {
        components.remove(Type.getClassName(componentClass));
        for (listener in listeners)
            listener.componentRemoved(this, componentClass);
    }

    public function removeAll() {
        components.clear();
    }

    public function registerListener(listener: ComponentListener) {
        this.listeners.add(listener);
    }

    public function unregisterListener(listener: ComponentListener) {
        this.listeners.remove(listener);
    }

}

interface ComponentListener {
    public function componentAdded(entity: Entity, component: Component): Void;
    public function componentRemoved(entity: Entity, component: Class<Component>): Void;
}