package economy;

import economy.Entity;
import economy.System;
import economy.Family;
import economy.EntityFamily;
import economy.utils.Process;

using Lambda;

class Space extends Process implements ComponentListener {
    private var entities: List<Entity>;
    private var systems: List<System>;

    private var globals: Map<String, Dynamic>;

    private var familyToEntities: Map<String, List<Entity>>;
    private var componentToFamily: Map<String, List<Family>>;
    private var entityFamilies: Map<String, EntityFamily>;

    private var componentToId: Map<String, Int>;
    private var idToComponent: Array<Class<Component>>;
    private var counter = 0;

    public function new() {
        entities = new List();
        systems = new List();
        familyToEntities = [];
        componentToFamily = [];
        entityFamilies = [];
        globals = [];

        componentToId = [];
        idToComponent = [];
    }

    public override function update(delta: Float) {
        super.update(delta);
        for (system in systems)
            system.update(delta);
    }

    public function addEntity(entity: Entity) {
        this.entities.add(entity);
        entity.registerListener(this);
        for (id => list in familyToEntities)
            if (idToFamily(id).matches(entity))
                list.add(entity);
    }

    public function getEntities(): EntityFamily {
        return getEntitiesFor(Family.identity);
    }

    public function getEntitiesFor(family: Family): EntityFamily {
        var id = familyToId(family);
        if (!familyToEntities.exists(id)) {
            addFamily(family);
        }
        if (!entityFamilies.exists(id))
            entityFamilies[id] = new EntityFamily(familyToEntities[id]);
        return entityFamilies[id];
    }

    public function removeEntity(entity: Entity) {
        entities.remove(entity);
        entity.unregisterListener(this);
        for (id => list in familyToEntities)
            if (idToFamily(id).matches(entity))
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
                familyToEntities[familyToId(family)].add(entity);
            else
                familyToEntities[familyToId(family)].remove(entity);
    }

    private function addFamily(family: Family) {
        familyToEntities[familyToId(family)] = entities.filter(e -> family.matches(e));

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
    

    public function addGlobal<T>(object: T) {
        globals[Type.getClassName(Type.getClass(object))] = object;
    }

    public function getGlobal<T>(c: Class<T>): T {
        return globals[Type.getClassName(c)];
    }

    public function removeGlobal<T>(c: Class<T>) {
        globals.remove(Type.getClassName(c));
    }

    public function getComponentId(component: Class<Component>): Int {
        var name = Type.getClassName(component);
        if (!componentToId.exists(name)) {
            componentToId[name] = counter++;
            idToComponent.push(component);
        }
        return componentToId[name];
    }

    public function familyToId(family: Family): String {
        // 0 -> nothing, 1 -> all, 2 -> one, 3 -> none
        var map = [for (_ in 0...counter) "0"];
        for (c in family.include)
            map[getComponentId(c)] = "1";
        for (c in family.ones)
            map[getComponentId(c)] = "2";
        for (c in family.exclude)
            map[getComponentId(c)] = "3";

        var total = "";
        for (s in map)
            total += s;
        return total;
    }

    public function idToFamily(id: String): Family {
        var builder = new FamilyBuilder();
        for (i in 0...id.length) {
            switch(id.charAt(i)) {
                case "0": 
                case "1": builder = builder.all([idToComponent[i]]);
                case "2": builder = builder.one([idToComponent[i]]);
                case "3": builder = builder.none([idToComponent[i]]);
                default: throw "Should not happen";
            }
        }
        return builder.get();
    } 


}