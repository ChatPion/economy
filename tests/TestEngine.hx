package tests;

using buddy.Should;

class TestEngine extends buddy.BuddySuite {
    public function new() {
        describe("Using Buddy", {
            var experience = "great";

            it("should be a great testing experience", {
                experience.should.be("great");
            });

        });
    }
}