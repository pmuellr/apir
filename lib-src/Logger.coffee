# Licensed under the Apache License. See footer for details.

path = require "path"

utils  = require "./utils"

Verbose = false

#-------------------------------------------------------------------------------
module.exports = class Logger

    #---------------------------------------------------------------------------
    @verbose: (value) ->
        Verbose = !!value if value?
        return Verbose

    #---------------------------------------------------------------------------
    constructor: (@prefix, @logDevice=console) ->

    #---------------------------------------------------------------------------
    log: (message) ->
        @logDevice.log "#{@prefix}: #{message}"

    #---------------------------------------------------------------------------
    vlog: (message) ->
        return if !Verbose
        @log message

    #---------------------------------------------------------------------------
    err: (message) ->
        @log "error: #{message}"
        throw Error message

    #---------------------------------------------------------------------------
    newLogger: (prefix) ->
        return new Logger "#{@prefix}: #{prefix}", @logDevice

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
