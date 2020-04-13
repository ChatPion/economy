package tests;

import ecs.IteratingSystem;
import ecs.Component;
import ecs.Entity;
import ecs.Family;
import ecs.Space;

using buddy.Should;
using Lambda;

class SnooperComponent implements Component {
    public var during(default, default): Bool;

    public function new() {
        this.during = false;
    }
}

class SnooperSystem extends IteratingSystem {
    public var before: Int = 0;
    public var after: Int = 0;

    public function new() {
        super(Family.all([SnooperComponent]).get());
    }

    public override function beforeAll(delta: Float) {
        super.beforeAll(delta);
        this.before++;
    }

    public override function processEntity(delta: Float, entity: Entity) {
        super.processEntity(delta, entity);
        entity.get(SnooperComponent).during = true;
    }

    public override function afterAll(delta: Float) {
        super.afterAll(delta);
        this.after++;
    }
}

class TestIteratingSystem extends buddy.BuddySuite {

    public function new() {
        describe("Using an IteratingSystem", {
            var space: Space;
            var system: IteratingSystem;

            beforeEach({
                space = new Space();
                system = new SnooperSystem();
                space.addSystem(system);

                var good1 = new Entity();
                var cmp1 = new SnooperComponent();
                good1.add(cmp1);
                space.addEntity(good1);

                var good2 = new Entity();
                var cmp2 = new SnooperComponent();
                good2.add(cmp2);
                space.addEntity(good2);
            });

            describe("when adding an IteratingSystem to a Space", {
                var bad: Entity;
                beforeEach({
                    bad = new Entity();
                    space.addEntity(bad);
                });

                it("should fetch matching entities", {
                    system.entities.length.should.be(2);
                    system.entities.has(bad).should.be(false);
                });
            });
    
            describe("when updating a space containing an IteratingSystem", {
                var space: Space;
                var system: SnooperSystem;
                var entity1: Entity;
                var entity2: Entity;
                var snooper1: SnooperComponent;
                var snooper2: SnooperComponent;

                beforeEach({
                    space = new Space();
                    system = new SnooperSystem();
                    space.addSystem(system);

                    entity1 = new Entity();
                    entity1.add(snooper1 = new SnooperComponent());
                    space.addEntity(entity1);

                    entity2 = new Entity();
                    entity2.add(snooper2 = new SnooperComponent());
                    space.addEntity(entity2);

                    space.update(1);
                });

                it("should call beforeAll once", {
                    system.before.should.be(1);
                });
                it("should call processEntity for all entities", {
                    snooper1.during.should.be(true);
                    snooper2.during.should.be(true);
                });
                it("should call afterAll once", {
                    system.after.should.be(1);
                });
            });
    
            describe("when modifying an entity matching the family to the Space", {
                var space: Space;
                var system: SnooperSystem;
                var inSystem: Entity;
                var notInSystem: Entity;

                beforeAll({
                    space = new Space();
                    
                    system = new SnooperSystem();
                    space.addSystem(system);

                    inSystem = new Entity();
                    inSystem.add(new SnooperComponent());
                    space.addEntity(inSystem);

                    notInSystem = new Entity();
                    space.addEntity(notInSystem);
                });

                describe("when adding a component to match the family", {
                    beforeEach({
                        notInSystem.add(new SnooperComponent());
                    });
                    
                    it("should add this entity to the system", {
                        system.entities.has(notInSystem).should.be(true);
                    });
                });

                describe("when removing a component not to match the family", {
                    beforeEach({
                        inSystem.remove(SnooperComponent);
                    });

                    it("should remove this entity from the system", {
                        system.entities.has(inSystem).should.be(false);
                    });
                });
            });
    
           
        });

    }

}