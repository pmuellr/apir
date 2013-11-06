# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

_      = require "underscore"
coffee = require "coffee-script"

reader = exports

BuiltInTypes = """
    Boolean
    Date
    Error
    Object
    Number
    String
    null
""".split /\s+/

Directives = """
    api
    __filename
    __dirname
    http
    object
    func
    title
    desc
    include
""".split /\s+/

#-------------------------------------------------------------------------------
# called from api.readAPI(fileName)
#-------------------------------------------------------------------------------
reader.readAPI = (api, fileName) ->
    api.vlog "processing #{fileName}"

    rdr = new Reader api, fileName
    result = rdr.read()

    api.title   = result.title if result.title?
    api.desc    = result.desc  if result.desc?
    api.https   = _.union api.https,    result.https
    api.funcs   = _.union api.funcs,    result.funcs
    api.objects = _.union api.objects,  result.objects

    return

#-------------------------------------------------------------------------------
class Reader

    #---------------------------------------------------------------------------
    constructor: (@api, fileName) ->
        @result = 
            https:      []
            funcs:      []
            objects:    []
            title:      undefined
            desc:       undefined

        @names = {}
        for name in BuiltInTypes
            @names[name] = name

        @__filename = fileName
        @__dirname  = path.dirname @__filename


    #---------------------------------------------------------------------------
    read: ->
        funcBody = @getFuncBody()

        args = _.map Directives, (directive) ->
            "var #{directive} = __directives.#{directive};\n"

        funcBody = "#{args.join('')}\n#{funcBody}"
        func = new Function "__directives", funcBody

        if @api.dumpJS
            @api.log "generated JavaScript:\nfunction(__directives){\n#{funcBody}\n}"

        directives = 
            api:            @api
            __filename:     @__filename
            __dirname:      @__dirname

        for directive in Directives
            directiveFunc = "directive_#{directive}"
            if _.isFunction @[directiveFunc]
                directives[directive] = @[directiveFunc].bind @

        func.call @names, directives
        
        @process_https()
        @process_funcs()
        @process_objects()

        return @result

    #---------------------------------------------------------------------------
    getFuncBody: ->
        fileName = @__filename

        if !fs.existsSync fileName
            fileName = "#{fileName}.api.coffee"

            if !fs.existsSync fileName
                throw Error "file not found: #{@__filename}"

            @__filename = fileName

        contents = fs.readFileSync @__filename, "utf-8"
        options = 
            bare: true

        return coffee.compile contents, options

    #---------------------------------------------------------------------------
    process_https: ->
        for http in @result.https
            fnResult = http.fn.call @names, http
            _.extend http, fnResult
            delete http.fn

            http.parms ?= {}

            parms = []
            for name, parm of http.parms
                parm.type = normalizeType parm.type
                parm.name = name
                parms.push parm

            http.parms    = parms
            http.response = normalizeType http.response

        return

    #---------------------------------------------------------------------------
    process_funcs: ->
        for func in @result.funcs
            fnResult = func.fn.call @names, func
            _.extend func, fnResult
            delete func.fn
    
            func.parms  ?= {}
    
            parms    = []
            for name, parm of func.parms
                parm.type = normalizeType parm.type
                parm.name = name
                parms.push parm
    
            func.parms  = parms
            func.result = normalizeType func.result

        return

    #---------------------------------------------------------------------------
    process_objects: ->
        for object in @result.objects
            fnResult = object.fn.call @names, object
            _.extend object, fnResult
            delete object.fn
    
            properties = []
            for name, property of object.properties
                property.type = normalizeType property.type
                property.name = name
                properties.push property
    
            object.properties = properties

        return

    #---------------------------------------------------------------------------
    directive_http: (method, uri, fn) ->
        @result.https.push
            definedIn:  @__filename
            method:     method
            uri:        uri
            fn:         fn

    #---------------------------------------------------------------------------
    directive_func: (namedValue) ->
        {name, value} = splitNamedValue namedValue

        @names[name] = name

        @result.funcs.push
            name:       name
            definedIn:  @__filename
            isFunction: true
            fn:         value

    #---------------------------------------------------------------------------
    directive_object: (namedValue) ->
        {name, value} = splitNamedValue namedValue

        @names[name] = name

        @result.objects.push 
            name:       name
            definedIn:  @__filename
            isObject:   true
            fn:         value

    #---------------------------------------------------------------------------
    directive_title: (text) ->
        @result.title = text

    #---------------------------------------------------------------------------
    directive_desc: (text) ->
        @result.desc = text

    #---------------------------------------------------------------------------
    directive_include: (fileName) ->
        relName = path.normalize path.join(@__dirname, fileName)

        reader.readAPI @api, relName

        for func in @api.funcs
            @names[func.name] = func.name

        for object in @api.objects
            @names[object.name] = object.name

        return            

#===============================================================================
splitNamedValue = (namedValue) ->
    for name, value of namedValue
        return {name, value}
    return null

#===============================================================================
normalizeType = (value, dimensions=0) ->
    if !value?
        result =
            name:   "null"
            isPrim: true
        return result

    if _.isArray value
        return normalizeType value[0], ++dimensions

    result = {}
    result.dimensions = dimensions if dimensions

    if _.isString value
        result.name   = value
        result.isPrim = true if value in BuiltInTypes

        return result

    switch value
        when Boolean then result.name = "Boolean";  result.isPrim = true
        when Date    then result.name = "Date";     result.isPrim = true
        when Error   then result.name = "Error";    result.isPrim = true
        when Number  then result.name = "Number";   result.isPrim = true
        when Object  then result.name = "Object";   result.isPrim = true
        when String  then result.name = "String";   result.isPrim = true
        else              result.name = "#{value}"; 

    return result

#-------------------------------------------------------------------------------
JL = (object) -> 
    return JSON.stringify object, null, 4

#-------------------------------------------------------------------------------
JS = (object) -> 
    return JSON.stringify object

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
