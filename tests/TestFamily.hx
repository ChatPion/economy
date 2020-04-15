package tests;

import economy.Component;
import economy.Entity;
import economy.Space;
import economy.Family;

using buddy.Should;
using Lambda;

private class C1 implements Component {
    public function new() {}
}

private class C2 implements Component {
    public function new() {}
}

private class C3 implements Component {
    public function new() {}
}

class TestFamily extends buddy.BuddySuite {
    public function new() {
        describe("When using families", {
            var space = new Space();
    
            var entity1 = new Entity();
            entity1.add(new C1());
            space.addEntity(entity1);

            var entity2 = new Entity();
            entity2.add(new C1());
            entity2.add(new C2());
            space.addEntity(entity2);

            var entity3 = new Entity();
            entity3.add(new C1());
            entity3.add(new C2());
            entity3.add(new C3());
            space.addEntity(entity3);

            var entity4 = new Entity();
            entity4.add(new C3());
            space.addEntity(entity4);

            describe("When creating an empty all Family", {
                var family = Family.all([]).get();
                var entities = space.getEntitiesFor(family);
    
                it("should get all entities", {
                    entities.length.should.be(4);
                });
            });
    
            describe("When creating an all Family", {
                var family = Family.all([C1, C2]).get();
                var entities = space.getEntitiesFor(family);
                
                it("should select entities completely matching the family", {
                    entities.has(entity2).should.be(true);
                });
    
                it("should select entities having more than the family", {
                    entities.has(entity3).should.be(true);
                });
    
                it("should not select entities partially matching the family", {
                    entities.has(entity1).should.be(false);
                });
    
                it("should not select entities not matching the family", {
                    entities.has(entity4).should.be(false);
                });
            });
    
            describe("When creating an empty one family", {
                var family = Family.one([]).get();
                var entities = space.getEntitiesFor(family);
    
                it("should select all entities", {
                    entities.length.should.be(4);
                });
            });
    
            describe("When creating a one family", {
                var family = Family.one([C1, C2]).get();
                var entities = space.getEntitiesFor(family);

                it("should select entities having all", {
                    entities.has(entity3).should.be(true);
                    entities.has(entity2).should.be(true);
                });
                it("should select entities having one", {
                    entities.has(entity1).should.be(true);
                });
                it("should not select entities having none", {
                    entities.has(entity4).should.be(false);
                });
            });
    
            describe("When creating an empty none family", {
                var family = Family.none([]).get();
                var entities = space.getEntitiesFor(family);
    
                it("should select all entities", {
                    entities.length.should.be(4);
                });
            });
    
            describe("When creating a none family", {
                var family = Family.none([C1, C2]).get();
                var entities = space.getEntitiesFor(family);

                it("should select entities having none", {
                    entities.has(entity4).should.be(true);
                });
                it("should not select entities having at least one", {
                    entities.has(entity1).should.be(false);
                });
                it("should not select entities having all", {
                    entities.has(entity2).should.be(false);
                    entities.has(entity3).should.be(false);
                });
            });
        });
    }
}