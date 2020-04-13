package tests;

import ecs.Family;
import ecs.EntityFamily;
import ecs.Entity;
import ecs.Space;
import ecs.Component;

using buddy.Should;
using Lambda;

class C implements Component {
    public function new() {

    }
}

class TestEntityFamily extends buddy.BuddySuite {
    public function new() {
        describe("When creating getting an EntityFamily", {
            var space = new Space();
            var good1 = new Entity();
            good1.add(new C());
            space.addEntity(good1);
            var good2 = new Entity();
            good2.add(new C());
            space.addEntity(good2);
            var bad = new Entity();
            space.addEntity(bad);

            var bag = space.getEntitiesFor(Family.all([C]).get());
            
            it("should contain matching entities", {
                bag.length.should.be(2);
                bag.has(bad).should.be(false);
            });
        });

        describe("When modifying entities of a space", {
            var space: Space;
            var bag: EntityFamily;
            var inBag: Entity;

            beforeEach({
                space = new Space();
                inBag = new Entity();
                inBag.add(new C());
                space.addEntity(inBag);
                bag = space.getEntitiesFor(Family.all([C]).get());
            });
            
            describe("when adding an entity", {
                var good: Entity;

                beforeEach({
                    good = new Entity();
                    good.add(new C());
                    space.addEntity(good);
                });

                it("should add the entity to the bag", {
                    bag.has(good).should.be(true);
                });
            });

            describe("when removing an entity", {
                beforeEach({
                    space.removeEntity(inBag);
                });

                it("should remove the entity from the bag", {
                    bag.has(inBag).should.be(false);
                });
            });
        });

        describe("When modifying components of an entity", {
            var space: Space;
            var bag: EntityFamily;
            var inBag: Entity;
            var notInBag: Entity;

            beforeEach({
                space = new Space();

                inBag = new Entity();
                inBag.add(new C());
                space.addEntity(inBag);
                
                notInBag = new Entity();
                space.addEntity(notInBag);

                bag = space.getEntitiesFor(Family.all([C]).get());
            });

            describe("when adding a component to make an entity match the bag", {
                beforeEach({
                    notInBag.add(new C());
                });

                it("should add the entity to the bag", {
                    bag.has(notInBag).should.be(true);
                });
            });

            describe("when removing a component to make an entity not match the bag", {
                beforeEach({
                    inBag.remove(C);
                });

                it("should remove the entity from the bag", {
                    bag.has(inBag).should.be(false);
                });
            });
        });
    }
}