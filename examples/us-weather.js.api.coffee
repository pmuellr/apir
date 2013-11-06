# Licensed under the Apache License. See footer for details.

title "us weather JavaScript APIs"

desc """
    APIs to return weather information for US locations
    using data from the US National Weather Service
    via their API - <http://graphical.weather.gov/xml/rest.php>
"""

include "us-weather.data"

#===============================================================================

object "exports" :->

    properties:

        getLocations:       
            type:           @GetLocations
            desc:           "get a list of popular locations and geo coordinates"

        getWeatherByGeo:    
            type:           @GetWeatherByGeo
            desc:           "get weather information for geo coordinates"

        getWeatherByZip:    
            type:           @GetWeatherByZip
            desc:           "get weather information for zipcode"

#===============================================================================

func GetLocations :->

    desc: "returns a list of popular locations with their geographic coordinates"

    parms:
        callback:   
            type:   @GetLocationsCallback
            desc:   "callback which delivers the location data"

    result: null

#===============================================================================
func GetLocationsCallback :->

    parms:
        err:
            type:   Error
            desc:   "error object, when an error occurs"

        data:   
            type:   @Locations
            desc:   "list of locations"

#===============================================================================

func GetWeatherByGeo  :->

    desc: "returns weather data for the specified location"

    parms:
        lat:    
            type:   Number
            desc:   "latitude"

        lon:    
            type:   Number
            desc:   "longitude"

        callback:
            type:   @GetWeatherCallback
            desc:   "callback which delivers the weather data"

#===============================================================================

func GetWeatherByZip  :->

    desc: "returns weather data for the specified location"

    parms:
        zip:    
            type:   Number
            desc:   "zipcode"

        callback:
            type:   @GetWeatherCallback
            desc:   "callback which delivers the weather data"

#===============================================================================
func GetWeatherCallback :->

    parms:
        err:
            type:   Error
            desc:   "error object, when an error occurs"

        data:   
            type:   @Weather
            desc:   "weather data"

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