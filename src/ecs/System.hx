package ecs;

import ecs.Entity;

interface System {
    private var isProcessing(default, default): Bool;

    public function update(delta: Float, entities: List<Entity>): Void;
}