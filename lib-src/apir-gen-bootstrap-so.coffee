# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

gen_bs = require "./apir-gen-bootstrap"

PROGRAM = path.basename __filename
PROGRAM = (PROGRAM.match /(.*)\..*/)[1]

#-------------------------------------------------------------------------------
exports.process = (api, options) ->
    {output, logger} = options

    logger = logger.newLogger PROGRAM
    fname  = "#{output}.html"

    logger.log "generating #{fname}"

    result = gen_bs.processString api

    result = """
        <!doctype html>
        <html>
            <meta charset="utf-8"> 
            <head>
                <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css">
                <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap-theme.min.css">
                <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>        
            </head>

            <body>

        #{result}

            </body>
            </html>
    """

    fs.writeFileSync fname, result

#-------------------------------------------------------------------------------
exports.processString = (api) ->
    return JSON.stringify(api, null, 4)    


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
