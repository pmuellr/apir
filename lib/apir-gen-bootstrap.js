// Generated by CoffeeScript 1.6.3
var PROGRAM, fs, path;

fs = require("fs");

path = require("path");

PROGRAM = path.basename(__filename);

PROGRAM = (PROGRAM.match(/(.*)\..*/))[1];

exports.process = function(api, options) {
  var fname, logger, output, result;
  output = options.output, logger = options.logger;
  logger = logger.newLogger(PROGRAM);
  fname = "" + output + ".html";
  logger.log("generating " + fname);
  result = exports.processString(api);
  return fs.writeFileSync(fname, result);
};

exports.processString = function(api) {
  return JSON.stringify(api, null, 4);
};