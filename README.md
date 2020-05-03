# levatr

This is a simple elevator implementation that works for buildings of various sizes. The design can be scaled to multiple floors and multiple elevators.

## System Design

![levatr System Design](https://raw.githubusercontent.com/goprag/levatr/master/levatr_design.png)

The elevator system has an elevator shaft and elevator car. Elevator shaft can span multiple floors and the elevator car can vertically move between floors. Each elevator has two request buttons per floor for making "up" and "down" requests. When one of the request buttons is clicked, the elevator controller is smart enough to find the nearest elevator that is either moving in the same direction or stationary. Elevator cars have level indicator buttons. When a level button is clicked, the elevator moves to desired level. The elevator can be configured to operate in single or multi-mode. In single mode operation, each elevator dispatches its own car. In multi-mode operation, the controller makes smart optimization decision to dispatch the elevator that offers least waiting time.

## Implementation Details

### Models

The models captures state information of various objects like elevator cars and elevator buttons.

### Views

The view draws elevator shafts, elevator cars, buttons, and floor level indicators. The view provides visual cue when buttons or floors are selected and turns them off when desired floor is reached.

### Controllers

The controllers check elevator requests and floor number selections. It does some  smart calculations to dispatch the elevator car with least waiting times. And when requests are met, it updates status info on all the models.

### Helpers

There are several helpe functions for various conversions and finding positions. 

        
## Developer setup

* install [love2d](https://love2d.org)
* checkout of source
* `love .`

## Configuration

levatr is highly parameterized through configuration file setup.lua. You can pick number of floors, number of elevators, operate in single or multi-mode, change various sizes and colors. The overall canvas is configured using conf.lua.
    


