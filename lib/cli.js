// Generated by CoffeeScript 1.6.3
var API, BuiltInGenerators, cli, fs, getGenerator, help, nopt, parseCommandLine, path, pkg, utils, _,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

fs = require("fs");

path = require("path");

nopt = require("nopt");

_ = require("underscore");

API = require("./api");

utils = require("./utils");

pkg = require("../package.json");

BuiltInGenerators = ["html", "json"];

cli = exports;

cli.run = function() {
  var api, apiGen, err, file, files, genName, genOptions, generator, options, _i, _len, _ref, _ref1;
  _ref = parseCommandLine(process.argv.slice(2)), files = _ref[0], options = _ref[1];
  if (options.help || (files.length === 0)) {
    help();
    return;
  }
  api = new API({
    verbose: options.verbose,
    dumpJS: options.dumpJS
  });
  file = files[0];
  try {
    api.readAPI(file);
  } catch (_error) {
    err = _error;
    api.log("error reading " + file + ": " + err);
    if (err.stack) {
      api.log("stack:\n" + err.stack);
    }
    return;
  }
  _ref1 = options.gen;
  for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
    genName = _ref1[_i];
    apiGen = api.clone();
    generator = getGenerator(apiGen, genName);
    if (generator == null) {
      continue;
    }
    genOptions = {
      output: options.output,
      logger: apiGen
    };
    generator.process(apiGen, genOptions);
  }
};

getGenerator = function(api, name) {
  var err, fullName;
  if (__indexOf.call(BuiltInGenerators, name) >= 0) {
    return require("./apir-gen-" + name);
  }
  fullName = path.resolve(name);
  try {
    return require(fullName);
  } catch (_error) {
    err = _error;
    api.log("error loading generator '" + name + "': " + err);
  }
};

parseCommandLine = function(argv) {
  var cmdLineOptions, defaultOptions, optionSpecs, options, parsed, shortHands;
  optionSpecs = {
    dumpJS: Boolean,
    gen: [String, Array],
    output: path,
    verbose: Boolean,
    help: Boolean
  };
  shortHands = {
    d: "--dumpJS",
    g: "--gen",
    o: "--output",
    v: "--verbose",
    "?": "--help",
    h: "--help"
  };
  parsed = nopt(optionSpecs, shortHands, argv, 0);
  if (argv[0] === "?") {
    parsed.help = true;
  }
  defaultOptions = {
    dumpJS: false,
    gen: [],
    help: false,
    output: "api",
    verbose: false
  };
  cmdLineOptions = _.pick(parsed, _.keys(optionSpecs));
  options = _.defaults(cmdLineOptions, defaultOptions);
  if (options.gen.length === 0) {
    options.gen.push(path.join(__dirname, "html"));
  }
  return [parsed.argv.remain, options];
};

help = function() {
  var text;
  text = "" + pkg.name + " " + pkg.version + "\n\n    do something with an API\n\nusage:\n    " + pkg.name + " [options] api-file\n\noptions:\n    -o --output <file>      name the base output path/file\n    -g --gen <generator>    run a generator\n    -v --verbose            be verbose\n    -d --dumpJS             dump api files as JavaScript\n    -h --help               display some help\n\nThe --gen option may be specified multiple times.\n\nA <generator> is a node module which will be invoked\nto generate some output.  Predefined generators\ninclude:\n\n    - html   generates HTML using bootstrap and angular\n    - json   generates a JSON file\n\nThe default generator if none is specified is `html`.\n\nThe default output file if none is specified is `./api`.\nThis will cause files `./api.json`, `./api.html`, etc\nto be generated.";
  return console.log(text);
};
