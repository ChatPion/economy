package tests;

import ecs.Entity;
import ecs.Space;
import ecs.System;

using buddy.Should;

private class DummySystem implements System {
    private var isProcessing(default, default): Bool;

    public function new() {

    }

    public function update(delta: Float) {
        
    }

    public function addedToSpace(space: Space) {

    }

    public function removedFromSpace(space: Space) {

    }
}

private class DummySystem2 extends DummySystem {
    public function new() {
        super();
    }
}

class TestSpace extends buddy.BuddySuite {
    public function new() {
        describe("When adding an entity to a Space", {
            var space = new Space();
            var entity = new Entity();
            
            space.addEntity(entity);
            it("should contain that entity", {
                space.getEntities().first().should.be(entity);
            });
        });

        describe("When removing an Entity", {
            var space = new Space();
            var entity1 = new Entity();
            var entity2 = new Entity();

            space.addEntity(entity1);
            space.addEntity(entity2);

            space.removeEntity(entity1);
            it("should not contain that entity", {
                space.getEntities().first().should.be(entity2);
            });
        });

        describe("When adding a System to a Space", {
            var space = new Space();
            var system = new DummySystem();

            space.addSystem(system);
            it("should contain that system", {
                space.getSystems().first().should.be(system);
            });
        });

        describe("When removing a System from a Space", {
            var space = new Space();
            var system1 = new DummySystem();
            var system2 = new DummySystem2();

            space.addSystem(system1);
            space.addSystem(system2);

            space.removeSystem(system1);
            it("should remove that system", {
                space.getSystems().first().should.be(system2);
            });
        });
    }
}