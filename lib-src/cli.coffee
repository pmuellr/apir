# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

nopt = require "nopt"
_    = require "underscore"

API   = require "./api"
utils = require "./utils"
pkg   = require "../package.json"

BuiltInGenerators = [
    "html"
    "json"
]

cli = exports

#-------------------------------------------------------------------------------
cli.run = ->
    [files, options] = parseCommandLine process.argv[2..]

    if options.help or (files.length is 0)
        help()
        return

    api = new API 
        verbose: options.verbose
        dumpJS:  options.dumpJS

    file = files[0]

    try 
        api.readAPI file
    catch err
        api.log "error reading #{file}: #{err}"
        api.log "stack:\n#{err.stack}" if err.stack
        return

    for genName in options.gen
        apiGen = api.clone()
        generator = getGenerator apiGen, genName
        continue if !generator?

        genOptions = 
            output: options.output
            logger: apiGen

        generator.process apiGen, genOptions

    return

#-------------------------------------------------------------------------------
getGenerator = (api, name) ->
    return require "./apir-gen-#{name}" if name in BuiltInGenerators

    fullName = path.resolve name

    try
        return require fullName
    catch err
        api.log "error loading generator '#{name}': #{err}"
        return 
    
#-------------------------------------------------------------------------------
parseCommandLine = (argv) ->

    optionSpecs =
        dumpJS:     Boolean
        gen:        [ String, Array ]
        output:     path
        verbose:    Boolean
        help:       Boolean

    shortHands =
        d:   "--dumpJS"
        g:   "--gen"
        o:   "--output"
        v:   "--verbose"
        "?": "--help"
        h:   "--help"

    parsed = nopt(optionSpecs, shortHands, argv, 0)

    parsed.help = true if argv[0] is "?"

    defaultOptions =
        dumpJS:     false
        gen:        []
        help:       false
        output:     "api"
        verbose:    false

    cmdLineOptions = _.pick parsed, _.keys optionSpecs

    options = _.defaults cmdLineOptions, defaultOptions

    if options.gen.length == 0
        options.gen.push (path.join __dirname, "html")

    return [parsed.argv.remain, options]

#-------------------------------------------------------------------------------
# print some help and then exit
#-------------------------------------------------------------------------------
help = ->
    text =  """
            #{pkg.name} #{pkg.version}

                do something with an API

            usage:
                #{pkg.name} [options] api-file

            options:
                -o --output <file>      name the base output path/file
                -g --gen <generator>    run a generator
                -v --verbose            be verbose
                -d --dumpJS             dump api files as JavaScript
                -h --help               display some help

            The --gen option may be specified multiple times.

            A <generator> is a node module which will be invoked
            to generate some output.  Predefined generators
            include:

                - html   generates HTML using bootstrap and angular
                - json   generates a JSON file

            The default generator if none is specified is `html`.

            The default output file if none is specified is `./api`.
            This will cause files `./api.json`, `./api.html`, etc
            to be generated.
            """
    console.log text

#-------------------------------------------------------------------------------
# Copyright 2013 Patrick Mueller
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#-------------------------------------------------------------------------------
