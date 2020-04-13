package tests;

import buddy.reporting.ConsoleColorReporter;

class MainCoverage {
    public static function main() {
        var reporter = new ConsoleColorReporter();

        var runner = new buddy.SuitesRunner([
            new tests.TestEngine(),
            new tests.TestEntity(),
            new tests.TestSystem(),
            new tests.TestSpace(),
            new tests.TestFamily(),
            new tests.TestIteratingSystem(),
            new tests.TestEntityFamily()
        ], reporter);

        runner.run();

        var logger = mcover.coverage.MCoverage.getLogger();
        logger.report();

        
        #if sys
        Sys.exit(runner.statusCode());
        #end
    }
}