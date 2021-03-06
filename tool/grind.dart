
library unscripted.tool.grind;

import 'dart:io';

import 'package:grinder/grinder.dart';

main(args) => grind(args);

@Task()
analyze() => new PubApplication('tuneup').run(['check']);

@Task()
test() => new PubApplication('test').run([]);

@Task()
coverage() {
  if (Platform.environment.containsKey('CI') &&
      Platform.environment['TRAVIS_DART_VERSION'] == 'stable') {
    new PubApplication('dart_coveralls').run(
      ['report',
       '--token', Platform.environment['REPO_TOKEN'],
       '--retry', '3',
       'test/all_tests.dart']);
  } else {
    // TODO: Run code coverage locally and output to console.
    //       Just skip uploading to coveralls.
    log('Skipping, code coverage is currently only run in CI.');
  }
}

@DefaultTask()
@Depends(analyze, test, coverage)
all() {}
