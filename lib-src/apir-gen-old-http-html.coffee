# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

_        = require "underscore"
Mustache = require 'mustache'

PROGRAM = path.basename __filename
PROGRAM = (PROGRAM.match /(.*)\..*/)[1]

#-------------------------------------------------------------------------------
exports.process = (api, options) ->
    {output, logger} = options

    logger = logger.newLogger PROGRAM
    fname  = "#{output}-http.html"

    html = Mustache.render HTMLTemplate, augment api

    logger.log "generating #{fname}"

    fs.writeFileSync fname, html

#-------------------------------------------------------------------------------
HTMLTemplate = """
<style>

    body {
        font-size:          150%;
    }

    table {
        font-size:          100%;
    }

    td {
        padding-right:      0.5em;
        vertical-align:     top;
    }

    h3, h4 { 
        margin-bottom:      0em; 
    }

    .typeName {
        font-style:         italic;
    }

    h3 {
        background-color:   #eee;
        padding:            0.5em 1em;
        margin-top:         0em;
        margin-left:        0em;
        border-radius:      10px;
    }

    .indent { 
        margin-left:        3em;
    }

    .bordered {
        border:             thin solid black;
        border-radius:      10px;
        padding:            0em 0em 0em 0em;
        margin-bottom:      1em;
    }

</style>

<title>{{title}}</title>

<h1>{{title}}</h1>
<p>{{desc}}

<!-- =================================== -->
<h2>HTTP requests</h2>
<div class=indent>

    {{#https}}
    <div class=bordered>
    <h3><tt>{{method}} {{uri}}</tt></h3>

        <div class=indent>
            <p>{{desc}}

            <h4>parms:</h4>
            <div class=indent>
                <table>

                {{#parms}}
                    <tr>
                        <td><b>{{name}}: </b>
                        <td>{{{typeLink}}}
                        {{#desc}}<td> - {{/desc}}
                        {{^desc}}<td>   {{/desc}}
                        <td>{{.}}
                {{/parms}}

                {{^parms}}
                    <tr><td>none
                {{/parms}}

                </table>
            </div>

            <h4>response:</h4>
            <div class=indent>
                <table>

                {{#response}}
                    <tr>
                        <td>{{{typeLink}}}
                        {{#desc}}<td> - {{/desc}}
                        {{^desc}}<td>   {{/desc}}
                        <td>{{desc}}
                {{/response}}

                {{^response}}
                    <tr><td>none
                {{/response}}

                </table>
            </div>

        </div>
    </div>
    {{/https}}

</div>

<!-- =================================== -->
<h2>objects</h2>
<div class=indent>

    {{#objects}}
    <div class=bordered>
        <h3 id={{name}}><tt>{{name}}</tt></h3>

        <div class=indent>
            <p>{{desc}}

            <h4>properties:</h4>
            <div class=indent>
                <table>
                {{#props}}
                    <tr>
                        <td><b>{{name}}: </b>
                        <td>{{{typeLink}}}
                        {{#desc}}<td> - {{/desc}}
                        {{^desc}}<td>   {{/desc}}
                        <td>{{desc}}
                {{/props}}

                {{^props}}
                    <tr><td>none
                {{/props}}
                </table>
            </div>

        </div>
    </div>

    {{/objects}}

</div>
"""

#-------------------------------------------------------------------------------
augment = (api) ->

    types = collectTypes api

    removeFunctions      api
    removeUnusedObjects  api, types
    augmentTypes         api

    return api

#-------------------------------------------------------------------------------
collectTypes = (api) ->
    types = {}

    for object in api.objects
        types[object.name] = object

    return types

#-------------------------------------------------------------------------------
removeFunctions = (api) ->

    for object in api.objects
        object.props = _.filter object.props, (prop) -> !prop.isFunction

#-------------------------------------------------------------------------------
removeUnusedObjects = (api, types) ->

    for http in api.https
        markUsed types, http.response.type

        for parm in http.parms
            markUsed types, parm.type

    api.objects = _.filter api.objects, (object) -> object.isUsed

#-------------------------------------------------------------------------------
markUsed = (types, typeName) ->
    type = types[typeName]

    return if !type?
    return if type.isUsed 

    type.isUsed = true

    for prop in type.props
        markUsed(types, prop.type)

    return

#-------------------------------------------------------------------------------
augmentTypes = (api) ->

    for object in api.objects
        for prop in object.props
            augmentType prop

    for http in api.https
        for parm in http.parms
            augmentType parm
        augmentType http.response

#-------------------------------------------------------------------------------
augmentType = (type) ->
    type.typeString = type.type
    type.typeString = "#{type.typeString}[]" if type.arity

    if type.isPrim
        type.typeLink   = "<span class=typeName>#{type.typeString}</span>"
    else
        type.typeLink   = "<a class=typeName href='##{type.type}'>#{type.typeString}</a>"

    return


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
