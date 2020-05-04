# levatr

This is a simple elevator implementation that works for buildings of various sizes. The design can be scaled to multiple floors and multiple elevators.

## System Design

![levatr System Design](https://raw.githubusercontent.com/goprag/levatr/master/levatr_design.png)

The elevator system has an elevator shaft and elevator car. The elevator shaft can span multiple floors and the 
elevator car can vertically move between floors. Each elevator has two request buttons per floor for making "up" 
and "down" requests. When one of the request buttons is clicked, the elevator controller is smart enough to find 
the nearest elevator that is either moving in the same direction or is stationary. Elevator cars have level indicator 
buttons. When a level button is clicked, the elevator moves to the desired level. The elevator can be configured to 
operate in single or multi-mode. In single mode operation, each elevator dispatches its own car. In multi-mode 
operation, the controller makes smart optimization decisions to dispatch the elevator with least waiting time.

[Video demo](https://youtu.be/FVe8HDRILyQ)

## Implementation Details

### Models

The models capture state information of various objects like elevator cars and elevator buttons.

### Views

The view draws elevator shafts, elevator cars, buttons, and floor level indicators. The view provides a visual cue when
buttons or floors are selected and turns them off when the desired floor is reached.

### Controllers

The controllers check elevator requests and floor number selections. They perform smart calculations to dispatch the elevator car with least waiting times. When requests are met, they update status info on all the models.

### Helpers

There are several helper functions for various conversions and finding positions. 

        
## Developer setup

Install [LOVE2D](https://love2d.org), and then run:

```bash
$ git clone github.com/goprag/levatr
$ love .
```

## Configuration

levatr is highly parameterized through the configuration file `setup.lua`. You can pick the number of floors, the number of elevators, operate in single or multi-mode, and change various sizes and colors. The overall canvas is configured using `conf.lua`.
    


