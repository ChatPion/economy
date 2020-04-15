package economy;

import economy.System;
import economy.EntityFamily;

class IteratingSystem extends System {

    public var entities(default, null): EntityFamily;
    public var family(default, null): Family;

    public function new(family: Family) {
        this.family = family;
    }

    public override function update(delta: Float): Void {
        super.update(delta);
        beforeAll(delta);
        for (entity in entities) {
            processEntity(delta, entity);
        }
        afterAll(delta);
    }

    public function beforeAll(delta: Float) {

    }

    public function processEntity(delta: Float, entity: Entity) {

    }

    public function afterAll(delta: Float) {

    }

    public override function addedToSpace(space: Space) {
        super.addedToSpace(space);
        this.entities = space.getEntitiesFor(family);
    }
}