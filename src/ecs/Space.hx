package ecs;

import ecs.Entity;
import ecs.System;
import ecs.Family;
import ecs.EntityFamily;
import ecs.Process;

using Lambda;

class Space extends Process implements ComponentListener {
    private var entities: List<Entity>;
    private var systems: List<System>;

    private var familyToEntities: Map<Family, List<Entity>>;
    private var componentToFamily: Map<String, List<Family>>;

    public function new() {
        entities = new List();
        systems = new List();
        familyToEntities = [];
        componentToFamily = [];
    }

    public override function update(delta: Float) {
        super.update(delta);
        for (system in systems)
            system.update(delta);
    }

    public function addEntity(entity: Entity) {
        this.entities.add(entity);
        entity.registerListener(this);
        for (family => list in familyToEntities)
            if (family.matches(entity))
                list.add(entity);
    }

    public function getEntities(): EntityFamily {
        return getEntitiesFor(Family.identity);
    }

    public function getEntitiesFor(family: Family): EntityFamily {
        if (!familyToEntities.exists(family)) {
            addFamily(family);
        }
        return new EntityFamily(familyToEntities[family]);
    }

    public function removeEntity(entity: Entity) {
        entities.remove(entity);
        entity.unregisterListener(this);
        for (family => list in familyToEntities)
            if (family.matches(entity))
                list.remove(entity);
    }

    public function addSystem(system: System) {
        systems.add(system);
        system.addedToSpace(this);
    }

    public function removeSystem(system: System) {
        systems.remove(system);
        system.removedFromSpace(this);
    }

    public function getSystems(): List<System> {
        return systems;
    }
    
    public function componentAdded(entity: Entity, component: Component) {
        updateFamiliesOfEntity(entity, Type.getClass(component));
    }

    public function componentRemoved(entity: Entity, component: Class<Component>) {
        updateFamiliesOfEntity(entity, component);
    }

    private function updateFamiliesOfEntity(entity: Entity, component: Class<Component>) {
        if (!componentToFamily.exists(Type.getClassName(component)))
            return;

        for (family in componentToFamily[Type.getClassName(component)])
            if (family.matches(entity))
                familyToEntities[family].add(entity);
            else
                familyToEntities[family].remove(entity);
    }

    private function addFamily(family: Family) {
        familyToEntities[family] = entities.filter(e -> family.matches(e));

        var components = new List<Class<Component>>();
        for (component in family.include)
            if (!components.has(component))
                components.add(component);
        for (component in family.ones)
            if (!components.has(component))
                components.add(component);
        for (component in family.exclude)
            if (!components.has(component))
                components.add(component);

        for (component in components) {
            var className = Type.getClassName(component);
            if (!componentToFamily.exists(className))
                componentToFamily[className] = new List();
            componentToFamily[className].add(family);
        }
    }

}