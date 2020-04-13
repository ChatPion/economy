package ecs;

import ecs.Entity;
import ecs.System;

class Space {
    var entities: List<Entity>;
    var systems: List<System>;

    public function new() {
        entities = new List();
        systems = new List();
    }

    public function addEntity(entity: Entity) {
        this.entities.add(entity);
    }

    public function getEntities(): List<Entity> {
        return this.entities;
    }

    public function removeEntity(entity: Entity) {
        entities.remove(entity);
    }

    public function addSystem(system: System) {
        systems.add(system);
    }

    public function removeSystem(system: System) {
        systems.remove(system);
    }

    public function getSystems(): List<System> {
        return systems;
    }
}