# Service Generator

If you need to build the generator, the simplest way is to directly pull the code:

```shell
$ git clone
$ cd google-api-objectivec-client-for-rest/Tools/ServiceGenerator
$ swift build -configuration release
```

With Xcode's default preferences, that will create a `build` directory next to the project file;
and you will find the built generator as `.build/release/ServiceGenerator`.

_NOTE:_ If you are using GTLR from CocoaPods, you likely will want to use the command line
option: `--gtlrFrameworkName` `GTLR` when generating a custom service so the generated
sources will `#import` the GTLR headers as
framework imports matching the CocoaPod.

For information on the options, invoke the generator with `--help`:

```Shell
$ .build/release/ServiceGenerator --help
Usage: ServiceGenerator --outputDir PATH [FLAGS] [ARGS]
...lots of usage info...
```
