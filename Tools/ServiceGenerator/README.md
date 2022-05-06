# Service Generator

If you need to build the generator, the simplest way is to directly pull the code:

```shell
$ git clone
$ cd google-api-objectivec-client-for-rest/Tools/ServiceGenerator
$ swift build -configuration release
```

You will find the built generator as `.build/release/ServiceGenerator`.

For information on the options, invoke the generator with `--help`:

```shell
$ .build/release/ServiceGenerator --help
Usage: ServiceGenerator --outputDir PATH [FLAGS] [ARGS]
...lots of usage info...
```
