package ecs;

interface Process {
    private var isProcessing(default, default): Bool;

    public function update(delta: Float): Void;
}