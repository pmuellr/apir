# Licensed under the Apache License. See footer for details.

#===============================================================================

object Location :->

    desc: "city, state and geographic position of a location"

    properties:
        
        lat:
            type:   Number
            desc:   "latitude of location"
        
        lon:
            type:   Number
            desc:   "longitude of location"
        
        city:
            type:   String
            desc:   "city of location"
        
        st:
            type:   String
            desc:   "state of location"

#===============================================================================

object Weather :->

    desc: "a collection of weather data"

    properties:
        
        date:
            type:   Date
            desc:   "when the weather data was created"
        
        lat:
            type:   Number
            desc:   "latitude of location"
        
        lon:
            type:   Number
            desc:   "longitude of location"
        
        data: 
            type:   @WeatherData
            desc:   "the weather data"

#===============================================================================

object WeatherData :->

    desc: "lists of weather readings"

    properties:
        
        temp:           
            type:   [@WeatherValue]
            desc:   "temperature"
        
        dew:            
            type:   [@WeatherValue]
            desc:   "dew point temperature"
        
        appt:           
            type:   [@WeatherValue]
            desc:   "apparent temperature"
        
        pop12:          
            type:   [@WeatherValue]
            desc:   "12 hourly probability of precipitation"
        
        qpf:            
            type:   [@WeatherValue]
            desc:   "liquid precipitation amount"
        
        snow:           
            type:   [@WeatherValue]
            desc:   "snow amount"
        
        iceaccum:       
            type:   [@WeatherValue]
            desc:   "ice accumulation"
        
        sky:            
            type:   [@WeatherValue]
            desc:   "cloud cover amount"
        
        rh:             
            type:   [@WeatherValue]
            desc:   "relative humidity"

#===============================================================================

object WeatherValue :->

    desc: "an individual weather reading"

    properties:

        value:      Number      
        date:       Date

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