package tests;

import ecs.Entity;
import ecs.Space;
import ecs.System;
import ecs.Component;

using buddy.Should;
using Lambda;


private class Counter {
    private static var i = 0;
    
    public static function count(): Int {
        return ++i;
    }

    public static function reset() {
        i = 0;
    }
}


private class DummySystem extends System {
    public var added: Space = null;
    public var removed: Space = null;

    public var updateOrder: Int = 0;

    public function new() {

    }

    public override function addedToSpace(space:Space) {
        super.addedToSpace(space);
        added = space;
    }

    public override function removedFromSpace(space:Space) {
        super.removedFromSpace(space);
        removed = space;
    }

    public override function update(delta: Float) {
        super.update(delta);
        this.updateOrder = Counter.count();
    }

}

private class DummySystem2 extends DummySystem {
    public function new() {
        super();
    }
}

private class MockSpace extends Space {
    public var componentAddedEntity: Entity = null;    
    public var componentAddedComponent: Component = null;
    public var componentRemovedEntity: Entity = null;
    public var componentRemovedComponent: Class<Component> = null;

    
    public function new() {
        super();
    }

    public override function componentAdded(entity: Entity, component: Component) {
        super.componentAdded(entity, component);
        this.componentAddedEntity = entity;
        this.componentAddedComponent = component;
    }

    public override function componentRemoved(entity: Entity, component: Class<Component>) {
        super.componentRemoved(entity, component);
        this.componentRemovedEntity = entity;
        this.componentRemovedComponent = component;
    }
}

private class MockComponent implements Component {
    public function new() {

    }
}

class TestSpace extends buddy.BuddySuite {
    public function new() {
        describe("When adding an entity to a Space", {
            var space = new Space();
            var entity = new Entity();
            
            space.addEntity(entity);
            it("should contain that entity", {
                space.getEntities().has(entity).should.be(true);
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
                space.getEntities().has(entity2).should.be(true);
            });
        });

        describe("When using entities in a space", {
            var space: MockSpace;
            var entity: Entity;

            beforeEach({
                space = new MockSpace();
                entity = new Entity();
                space.addEntity(entity);
            });

            describe("when modifying an entity", {
                var component: Component;

                beforeEach({
                    component = new MockComponent();
                    entity.add(component);
                    entity.remove(MockComponent);
                });

                it("should call componentAdded", {
                    space.componentAddedComponent.should.be(component);
                    space.componentAddedEntity.should.be(entity);
                });

                it("should call componentRemoved", {
                    space.componentRemovedComponent.should.be(MockComponent);
                    space.componentRemovedEntity.should.be(entity);
                });
            });
        });

        describe("When adding a System to a Space", {
            var space = new Space();
            var system = new DummySystem();

            space.addSystem(system);
            it("should contain that system", {
                space.getSystems().first().should.be(system);
            });

            it("should call addedToSpace", {
                system.added.should.be(space);
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

            it("should call removedFromSpace", {
                system1.added.should.be(space);
            });
        });

        describe("When updating a Space", {
            var space: Space;
            var system1: DummySystem;
            var system2: DummySystem2;

            beforeEach({
                Counter.reset();
                space = new Space();
                system1 = new DummySystem();
                space.addSystem(system1);
                system2 = new DummySystem2();
                space.addSystem(system2);

                space.update(1);
            });

            it("should update systems in the added order", {
                system1.updateOrder.should.be(1);
                system2.updateOrder.should.be(2);
            });
        });
    }
}