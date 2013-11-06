# Licensed under the Apache License. See footer for details.

title "us weather HTTP APIs"

desc """
    APIs to return weather information for US locations
    using data from the US National Weather Service
    via their API - <http://graphical.weather.gov/xml/rest.php>
"""

include "us-weather.data"

#===============================================================================

http "GET", "/api/v1/weather-locations.json", ->

    name: "Get Weather Locations"

    desc: "returns a list of popular locations with their geographic coordinates"

    response:   [@Location]

#===============================================================================

http "GET", "/api/v1/weather-by-geo/:lat/:lon.json", ->

    name: "Get Weather By Location"
    
    desc: "returns weather data for the specified location"

    parms:
        lat:    
            type:   Number
            desc:   "latitude"

        lon:    
            type:   Number
            desc:   "longitude"

    response:       @Weather

#===============================================================================

http "GET", "/api/v1/weather-by-zip/:zip.json", ->

    name: "Get Weather By Zipcode"

    desc: "returns weather data for the specified location"

    parms:
        zip:    
            type:   Number
            desc:   "zipcode"

    response:       @Weather

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