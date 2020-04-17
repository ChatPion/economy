package tests;

import economy.System;
import economy.Engine;
import economy.Space;

using buddy.Should;
using Lambda;

private class SystemMock extends System {
    public var updateCalled: Bool = false;

    public function new() {
        
    }

    public override function update(delta: Float) {
        updateCalled = true;
    }
}

class TestEngine extends buddy.BuddySuite {
    public function new() {
        describe("When using an Engine", {
            var engine: Engine;

            beforeEach({
                engine = new Engine();
            });

            describe("when adding a space to the engine", {
                var space: Space;

                beforeEach({
                    space = new Space();
                    engine.add(space, 0);
                });

                it("should add the space", {
                    engine.spaces[0].should.be(space);
                });

                describe("when adding another space with the same id", {
                    var space2: Space;
    
                    beforeEach({
                        space2 = new Space();
                        engine.add(space2, 0);
                    });

                    it("should replace the previous space", {
                        engine.spaces[0].should.be(space2);
                    });
                });

                describe("when adding another space with a different id", {
                    var space2: Space;

                    beforeEach({
                        space2 = new Space();
                        engine.add(space2, 1);
                    });

                    it("should keep both spaces", {
                        engine.spaces[0].should.be(space);
                        engine.spaces[1].should.be(space2);
                    });

                    describe("when removing a space", {
                        beforeEach({
                            engine.remove(0);
                        });

                        it("should remove it", {
                            engine.spaces.exists(0).should.be(false);
                        });

                        it("should not remove the others", {
                            engine.spaces[1].should.be(space2);
                        });
                    });
                });
            });

            describe("when updating the engine", {
                var system1: SystemMock;
                var system2: SystemMock;
                
                beforeEach({
                    system1 = new SystemMock();
                    system2 = new SystemMock();

                    var space1 = new Space();
                    space1.addSystem(system1);
                    
                    var space2 = new Space();
                    space2.addSystem(system2);

                    engine.add(space1, 1);
                    engine.add(space2, 2);

                    engine.update(1);
                });

                it("should update all spaces", {
                    system1.updateCalled.should.be(true);
                    system2.updateCalled.should.be(true);
                });
            });
        });
    }
}