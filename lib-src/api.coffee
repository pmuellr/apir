# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

_      = require "underscore"
coffee = require "coffee-script"

pkg      = require "../package.json"
utils    = require "./utils"
reader   = require "./reader"
Logger   = require "./Logger"

BuiltInTypes = { Object, String, Number, Boolean, Date, Error }

#-------------------------------------------------------------------------------
module.exports = class API 

    #---------------------------------------------------------------------------
    constructor: (options) ->

        logDevice = options?.logDevice || console
        verbose   = options?.verbose   || false
        @dumpJS   = options?.dumpJS    || false

        Logger.verbose verbose
        @logger = new Logger pkg.name, logDevice

        @https   = []
        @funcs   = []
        @objects = []

    #---------------------------------------------------------------------------
    clone: ->
        clone = new API

        clone.https   = JSON.parse JSON.stringify @https  
        clone.funcs   = JSON.parse JSON.stringify @funcs  
        clone.objects = JSON.parse JSON.stringify @objects

        return clone

    #---------------------------------------------------------------------------
    log: (message) ->    
        @logger.log message

        return @

    #---------------------------------------------------------------------------
    vlog: (message) ->    
        @logger.vlog message

        return @

    #---------------------------------------------------------------------------
    newLogger: (name) ->    
        return @logger.newLogger name

    #---------------------------------------------------------------------------
    readAPI: (fileName) ->  
        reader.readAPI @, fileName  

        return @

    #---------------------------------------------------------------------------
    toJSON: ->  
        { @https , @funcs, @objects }

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
