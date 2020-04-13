package ecs;

class Process {
    private var isProcessing(default, default): Bool = true;

    public function update(delta: Float) {
        if (!isProcessing)
            return;
    }
}