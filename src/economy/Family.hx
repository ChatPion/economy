package economy;

import economy.Component;

using Lambda;

class Family {

    public static var identity = new Family(new List(), new List(), new List());

    public var include(default, null) : List<Class<Component>>;
    public var ones(default, null) : List<Class<Component>>;
    public var exclude(default, null) : List<Class<Component>>;

    public function new(include: List<Class<Component>>, ones: List<Class<Component>>, exclude: List<Class<Component>>) {
        this.include = include;
        this.ones = ones;
        this.exclude = exclude;
    }

    public static function all(classes: Array<Class<Component>>) : FamilyBuilder {
        return new FamilyBuilder().all(classes);
    }

    public static function none(classes: Array<Class<Component>>) : FamilyBuilder {
        return new FamilyBuilder().none(classes);
    }

    public static function one(classes: Array<Class<Component>>) : FamilyBuilder {
        return new FamilyBuilder().one(classes);
    }

    public function matches(entity: Entity): Bool {
        return !include.exists(c -> !entity.has(c))
        && (ones.empty() || ones.exists(c -> entity.has(c)))
        && !exclude.exists(c -> entity.has(c));
    }

}

class FamilyBuilder {

    private var include: List<Class<Component>>;
    private var ones: List<Class<Component>>;
    private var exclude: List<Class<Component>>;

    public function new() {
        this.include = new List();
        this.ones = new List();
        this.exclude = new List();
    }

    public function get() : Family {
        return new Family(include, ones, exclude);
    }

    public function all(classes: Array<Class<Component>>) : FamilyBuilder {
        addDistinct(classes, include);
        return this;
    }

    public function one(classes: Array<Class<Component>>) : FamilyBuilder {
        addDistinct(classes, ones);
        return this;
    }

    public function none(classes: Array<Class<Component>>) : FamilyBuilder {
        addDistinct(classes, exclude);
        return this;
    }

    private function addDistinct(classes: Array<Class<Component>>, target: List<Class<Component>>) {
        for (c in classes)
            if (!target.has(c))
                target.add(c);
    }

}