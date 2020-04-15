package tests;

import economy.Entity;
import economy.Component;

using buddy.Should;

class TestComponent1 implements Component {
    public function new() {}
}
class TestComponent1Child extends TestComponent1 {
}
class TestComponent2 implements Component {
    public function new() {}
}
class TestComponent3 implements Component {
    public function new() {}
}

class TestEntity extends buddy.BuddySuite {
    public function new() {
        describe("When adding", {
            describe("a component to an Entity", {
                var entity = new Entity();
                var cmp1 = new TestComponent1();
                entity.add(cmp1);
    
                it("should have this component", {
                    entity.has(TestComponent1).should.be(true);
                });
    
                it("should not have another component", {
                    entity.has(TestComponent2).should.not.be(true);
                });
            });
    
            describe("two components of different types to an Entity", {
                var entity = new Entity();
                var cmp1 = new TestComponent1();
                var cmp2 = new TestComponent2();
                entity.add(cmp1);
                entity.add(cmp2);

                it("should have both", {
                    entity.has(TestComponent1).should.be(true);
                    entity.has(TestComponent2).should.be(true);
                });
            });
    
            describe("the same type of component twice to an Entity", {
                var entity = new Entity();
                var cmp1 = new TestComponent1();
                var cmp1bis = new TestComponent1();
                entity.add(cmp1);
                entity.add(cmp1bis);

                it("should use the latest added component", {
                    entity.has(TestComponent1).should.be(true);
                    entity.get(TestComponent1).should.be(cmp1bis);
                });
            });
        });

        describe("When getting", {
            var entity = new Entity();
            var cmp1 = new TestComponent1();
            entity.add(cmp1);

            describe("a component that exists", {
                var cmp = entity.get(TestComponent1);
                it("should return the requested component", {
                    cmp.should.be(cmp1);
                });
            });
            describe("a component that does not exist", {
                var cmp = entity.get(TestComponent2);
                it("should return null", {
                    cmp.should.be(null);
                });
            });
        });
        

        describe("When removing", {
            var entity = new Entity();
            
            beforeEach({
                entity.add(new TestComponent1());
                entity.add(new TestComponent2());
            });

            describe("a component from an Entity", {
                beforeEach({
                    entity.remove(TestComponent1);
                });

                it("should remove the given component class", {
                    entity.has(TestComponent1).should.be(false);
                });
                it("should not remove other components", {
                    entity.has(TestComponent2).should.be(true);
                });
            });
    
            describe("a component that does not exist in an Entity ", {
                it("should not raise an error", {
                    entity.remove.bind(TestComponent3).should.not.throwAnything();
                });
            });
        });

        describe("When using component inheritance", {
            var entity: Entity;
            var parent = new TestComponent1();
            var child = new TestComponent1Child();

            beforeEach({
                entity = new Entity();
            });

            describe("when using a parent component", {
                beforeEach({
                    entity.add(parent);
                });

                it("should not have the child", {
                    entity.has(TestComponent1Child).should.be(false);
                });

                describe("when getting the parent component", {
                    it("should return the component", {
                        entity.get(TestComponent1).should.be(parent);
                    });
                });

                describe("when getting the child component", {
                    it("should return null", {
                        entity.get(TestComponent1Child).should.be(null);
                    });
                });
            });

            describe("When using a child", {
                beforeEach({
                    entity.add(child);
                });

                it("should not add a parent", {
                    entity.has(TestComponent1).should.be(false);
                });

                describe("when getting the child component", {
                    it("should return the component", {
                        entity.get(TestComponent1Child).should.be(child);
                    });
                });

                describe("when getting the parent component", {
                    it("should return null", {
                        entity.get(TestComponent1).should.be(null);
                    });
                });
            });

            describe("When using a child and a parent", {
                beforeEach({
                    entity.add(child);
                    entity.add(parent);
                });

                it("should have both",{
                    entity.has(TestComponent1).should.be(true);
                    entity.has(TestComponent1Child).should.be(true);
                });

                describe("when removing the parent", {
                    beforeEach({
                        entity.remove(TestComponent1);
                    });

                    it("should remove the parent", {
                        entity.has(TestComponent1).should.be(false);
                    });

                    it("should not remove the child", {
                        entity.has(TestComponent1Child).should.be(true);
                    });
                });

                describe("when removing the child", {
                    beforeEach({
                        entity.remove(TestComponent1Child);
                    });

                    it("should not remove the parent", {
                        entity.has(TestComponent1).should.be(true);
                    });

                    it("should remove the child", {
                        entity.has(TestComponent1Child).should.be(false);
                    });
                });
            });
        }); 

        describe("When removing all components", {
            var entity = new Entity();
            entity.add(new TestComponent1());
            entity.add(new TestComponent2());
            entity.removeAll();

            it("should remove all components", {
                entity.has(TestComponent1).should.be(false);
                entity.has(TestComponent2).should.be(false);
            });
        });
    }
}