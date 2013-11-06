# Licensed under the Apache License. See footer for details.

fs   = require "fs"
path = require "path"

gen_html = require "./apir-gen-html"

PROGRAM = path.basename __filename
PROGRAM = (PROGRAM.match /(.*)\..*/)[1]

#-------------------------------------------------------------------------------
exports.process = (api, options) ->
    {output, logger} = options

    logger = logger.newLogger PROGRAM

    htmlFile    = path.join __dirname, "apir-gen-html.html"
    htmlContent = fs.readFileSync htmlFile, "utf8"

    htmlContent = htmlContent.replace /%api-title%/g, api.title
    htmlContent = htmlContent.replace /%api-json%/g,  JSON.stringify(api, null, 4)

    outFile  = "#{output}.html"
    logger.log "generating #{outFile}"
    fs.writeFileSync outFile, htmlContent

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
