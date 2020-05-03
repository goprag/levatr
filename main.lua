setup = require("setup")
    
-- Models

elevatorCars = {}
for i=1,setup.elevators do
    elevatorCars[i] = {moving=0,current=1, dest=nil, selected={}}
    for j=1,setup.elevatorFloors do
        elevatorCars[i].selected[j] = false
    end
end
    
elevatorButtons = {}
for i=1,setup.elevators do
    elevatorButtons[i] = {}
    for j=1,setup.elevatorFloors do
       elevatorButtons[i][j] = {up=false, down=false}
    end
end


-- View
    
-- Draw a box of specified dimension with specified color
function getBox(x, y, w, h, cf, cb)
    love.graphics.setColor(cf.r,cf.g,cf.b)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(cb.r, cb.g, cb.b)
    love.graphics.rectangle("line", x, y, w, h)
end

-- Draw elevator button up    
function elevatorButtonUp(x,y,cf, cb)
    d = elevatorButtonDim(x,y,true)
    getBox(d.x, d.y, d.w, d.h, cf, cb)
    w = d.w/2
    up = love.graphics.newText(love.graphics.getFont(), "V")
    angle = math.pi
    love.graphics.draw(up, d.x + w + w/2, d.y + d.h, angle)
end

-- Draw elevator button down
function elevatorButtonDown(x,y,cf, cb)
    d = elevatorButtonDim(x,y,false)
    getBox(d.x, d.y, d.w, d.h, cf, cb)
    w = d.w/2
    down = love.graphics.newText(love.graphics.getFont(), "V")
    love.graphics.draw(down, d.x + w/2, d.y, 0)
end

-- Draw elevator floor
function elevatorFloor(e, f, x, y, cf, cb, elCar)
    getBox(x,y,setup.elevatorWidth,setup.elevatorHeight, cf,cb)
    if not elCar then
        fcol = setup.elevatorButtonColor
        pcol = setup.elevatorButtonPressColor
        if elevatorButtonStatus(e,f,true) then
            elevatorButtonUp(x, y, pcol, setup.elevatorButtonColorBorder)
            elevatorButtonDown(x,y, fcol, setup.elevatorButtonColorBorder)
        elseif elevatorButtonStatus(e,f,false) then
            elevatorButtonUp(x, y, fcol, setup.elevatorButtonColorBorder)
            elevatorButtonDown(x,y, pcol, setup.elevatorButtonColorBorder)

        else
            elevatorButtonUp(x, y, fcol, setup.elevatorButtonColorBorder)
            elevatorButtonDown(x,y, fcol, setup.elevatorButtonColorBorder)
        end
    end
end

-- Draw elevator floor level indicator numbers
-- elevatorFloorLevelIndicatorNum
--    x,y: elevatorfloor with setup.elevatorFloorLevelIndicatorOffset
--    n: level num
--    cf: font color
function elevatorFloorLevelIndicatorNum(x, y, n, cf)
    d = elevatorFloorLevelIndicatorNumDim(x, y, n)
    love.graphics.setColor(cf.r, cf.g, cf.b)
    love.graphics.print(n, d.x, d.y )    
end

-- Draw elevator floor level indicators
function elevatorFloorLevelIndicator(e, x, y, cf, cb)
    x = x + setup.elevatorFloorLevelIndicatorOffset
    y = y + setup.elevatorFloorLevelIndicatorOffset
    w = setup.elevatorFloorLevelIndicatorWidth
    h = setup.elevatorFloorLevelIndicatorHeight
    getBox(x,y, w, h, cf,cb)
    for f = 1, setup.elevatorFloors do
        if elevatorCars[e].selected[f] then
            elevatorFloorLevelIndicatorNum(x, y, f, setup.elevatorFloorLevelIndicatorSelectionColor)
        else
            elevatorFloorLevelIndicatorNum(x, y, f, cb)
        end
    end    
end 

-- Draw elevator
function elevator(elevatorNum, floorNum, cf, cb)
    --e = elevatorFloorPos(elevatorNum, setup.elevatorFloors-floorNum+1)
    e = elevatorFloorPos(elevatorNum, floorNum)
    elevatorFloor(e.e, e.f, e.x, e.y, cf, cb, true)
    elevatorFloorLevelIndicator(e.e, e.x, e.y, cf, setup.elevatorFloorLevelIndicatorColorBorder)
end

    
-- Draw multiple elevator floors
function multipleElevatorFloors(x, y, e, cf, cb)
    for f = 1, setup.elevatorFloors do
        elevatorFloor(e, f, x,y,cf,cb, false)
        y = y + setup.elevatorHeight
    end
end

-- Draw multiple elevators
function multipleElevators(elev)
    x = setup.elevatorFirstX
    y = setup.elevatorFirstY
    for e = 1, elev do
        multipleElevatorFloors(x, y, e, setup.elevatorShaftColorFill, setup.elevatorShaftColorBorder)
        x = x + setup.elevatorWidth + setup.elevatorOffset
    end

end 


-- Draw the entire canvas
elevatorDest = {}
initialSetup = 1
function love.draw()
   love.graphics.setBackgroundColor(setup.canvasBackColor.r, setup.canvasBackColor.g, setup.canvasBackColor.b)
   love.graphics.setColor(setup.canvasSetColor.r, setup.canvasSetColor.g, setup.canvasSetColor.b)

    multipleElevators(setup.elevators)

    for i=1,setup.elevators do
        elevator(i, elevatorCars[i].current, setup.elevatorCarColorFill, setup.elevatorCarColorBorder)
    end
    
    if initialSetup == 1 then
        for i=1,setup.elevators do
            elevatorDest[i] = 1
        end
        initialSetup = 0
    end
    -- elevatorCar controller
    for i=1,setup.elevators do
        if elevatorCars[i].moving == 0 then
            moveElevatorTo(i,elevatorDest[i])
        end
    end
end

-- Update the entire canvas
function love.update(dt)
    for i=1,setup.elevators do
        if elevatorCars[i].moving == 1 then
            elevatorCars[i].current = elevatorCars[i].current + dt
            if elevatorCars[i].current >= elevatorCars[i].dest then
                elevatorCars[i].current = elevatorCars[i].dest
                elevatorCars[i].moving = 0
                --elevatorButtons[i][elevatorFloorNum(elevatorCars[i].dest)] = {up=false,down=false} -- reset buttons once you reach the floor
                elevatorSmartButtonReset(i, elevatorFloorNum(elevatorCars[i].dest))
                elevatorCars[i].selected[elevatorCars[i].dest] = false
            end
        elseif elevatorCars[i].moving == -1 then
            elevatorCars[i].current = elevatorCars[i].current - dt
            if elevatorCars[i].current <= elevatorCars[i].dest then
                elevatorCars[i].current = elevatorCars[i].dest
                elevatorCars[i].moving  = 0
                --elevatorButtons[i][elevatorFloorNum(elevatorCars[i].dest)] = {up=false,down=false} -- reset buttons once you reach the floor
                elevatorSmartButtonReset(i, elevatorFloorNum(elevatorCars[i].dest))
                elevatorCars[i].selected[elevatorCars[i].dest] = false 
            end
        end
    end
end 

-- Helpers

-- Get each elevator position coordinates
function elevatorPos(elevatorNum)
   return {x=setup.elevatorFirstX + (elevatorNum - 1)*setup.elevatorWidth + (elevatorNum-1)*setup.elevatorOffset, y=setup.elevatorFirstY}
end

-- Get floor number from bottom up
function elevatorFloorNum(floorNum)
    return setup.elevatorFloors-floorNum+1
end

-- For a specific elevator and floor number, get elevator coordinates 
function elevatorFloorPos(elevatorNum, floorNum)
    floorNum = elevatorFloorNum(floorNum)
    e = elevatorPos(elevatorNum)
    e.y = e.y + setup.elevatorHeight*(floorNum-1)
    return {e=elevatorNum, f=floorNum, x=e.x,y=e.y}
end

-- Get elevator button dimensions
-- elevatorButtonDim
--  x,y: elevator floor corner
--   up: boolen for up(true) or down(false)
function elevatorButtonDim(x,y,up)
    w = love.graphics.getFont():getWidth("V")
    h = love.graphics.getFont():getHeight("V")
    x1 = x - w*2
    if up then
        offset = (setup.elevatorHeight/2) - h
    else
        offset = (setup.elevatorHeight/2)
    end
    y1 = y + offset
    d = {x=x1, y=y1, w=w*2, h=h}
    return d
end

-- Get elevator floor level indicator number dimensions, relative to the indicator panel
function elevatorFloorLevelIndicatorNumDim(x, y, n)
    w = love.graphics.getFont():getWidth(n)
    h = love.graphics.getFont():getHeight(n)
    return {x = x + w + (n-1)*( 2*w), y = y, w = w, h = h}
end

-- Get elevator floor level indicator number dimensions, relative the floor
function elevatorFloorLevelIndicatorNumDimFromFloorCorner(x, y, n)
    d = elevatorFloorLevelIndicatorNumDim(x, y, n)
    return {x=d.x + setup.elevatorFloorLevelIndicatorOffset, y=d.y + setup.elevatorFloorLevelIndicatorOffset, w = w, h = h}
end

    
-- Check if elevatorCar is on a specific floor
function isElevatorCarOnFloor(e,f)
    if setup.siloMode then
        if elevatorCars[e].current == f then
            return true
        else
            return false
        end
    end
    
    for i=1,setup.elevators do
        if elevatorCars[i].current == f then
            return true
        end
    end
    return false
end

-- Get all stationary elevators
function findElevatorNotMoving(f)
    ed = {e=nil,d=nil}
    for i=1,setup.elevators do
        if elevatorCars[i].moving == 0 then
            di = math.abs(math.floor(elevatorCars[i].current) - f)
            if ed.d == nil or ed.d > di then
                ed.e = i
                ed.d = di
            end
       end
    end
    return ed
end

 --smart find nearest elevator
function smartFindElevator(e1, f)
    if e1.e == nil then
       e = findElevatorNotMoving(f)
    else
       e2 = findElevatorNotMoving(f)
       if e2.d ~= nil and e1.d < e2.d then
           e = e1
       else
           e = e2
       end
    end
    return e
end
        
-- find best elevator for going down from a given floor
function findElevatorGoingDown(f)
    ed = {e=nil,d=nil}
    for i=1,setup.elevators do
        if elevatorCars[i].moving < 0 and elevatorCars[i].current > f then
            di = math.floor(elevatorCars[i].current) - f
            if ed.d == nil or ed.d > di then
                ed.e = i
                ed.d = di
            end
        end
    end

    return smartFindElevator(ed, f)        
end

-- find best elevator for going up from a given floor
function findElevatorGoingUp(f)
    ed = {e=nil,d=nil}
    for i=1,setup.elevators do
        if elevatorCars[i].moving > 0 and elevatorCars[i].current > f then
            di = math.floor(elevatorCars[i].current) - f
            if ed.d == nil or ed.d > di then
                ed.e = i
                ed.d = di
            end
        end
    end
    return smartFindElevator(ed, f)
end

-- Find the elevator destination
function smartFindElevatorDest(e,ede)
    if setup.siloMode then
        return e
    else
        return ede
    end
end
    
-- Reset all elevator buttons to default on floor
function elevatorsButtonReset(f)
    for e=1,setup.elevators do
        elevatorButtonReset(e,f)
    end
end
    
-- Reset elevator button to default on specific elevator on a floor
function elevatorButtonReset(e,f)
      elevatorButtons[e][f] = {up=false,down=false} -- reset buttons once you reach the floor
end

-- Smart reset button based on mode
function elevatorSmartButtonReset(e,f)
    if setup.siloMode then
        return elevatorButtonReset(e,f)
    else
        return elevatorsButtonReset(f)
    end
end

    
-- Get single elevator button status
function singleElevatorButtonStatus(e, f, up)
    if up then
        if elevatorButtons[e][f].up then
            return true
        end
    else
        if elevatorButtons[e][f].down then
            return true
        end
    end
    return false
end

-- Get all elevator button status based on mode
function elevatorButtonStatus(e, f, up)
    if setup.siloMode then
        return singleElevatorButtonStatus(e,f, up)
    else
        for i=1,setup.elevators do
            if singleElevatorButtonStatus(i,f,up) then
                return true
            end
        end
    end
    return false
end

-- From the dimensions find elevator floor num
function findElevatorFloorLevelIndicatorNum(dim, pressedDim)
    for i = 1, setup.elevatorFloors do
        num = elevatorFloorLevelIndicatorNumDimFromFloorCorner(dim.x,dim.y, i)
        if isObjectPressed(num, pressedDim) then
            return i
        end
    end
    return 0
end

-- Controllers
-- Move elevator to specific floor
function moveElevatorTo(elevatorNum,to)
    if to > elevatorCars[elevatorNum].current then
        elevatorCars[elevatorNum].moving = 1
    elseif to < elevatorCars[elevatorNum].current then
        elevatorCars[elevatorNum].moving = -1
    end
    elevatorCars[elevatorNum].dest = to
end


-- isObjectPressed
-- o: object dimension
-- p: pressed dimension
function isObjectPressed(o, p)
    if (p.x > o.x and p.x < o.x+o.w and p.y < o.y + o.h and p.y > o.y) then
        return true
    else
        return false
    end
end

function getObjectPressed(x,y)
    for e=1,setup.elevators do
        for f=1,setup.elevatorFloors do
            dim = elevatorFloorPos(e,f)
            pressedDim = {x=x,y=y}
            up = elevatorButtonDim(dim.x,dim.y,true)

            if isObjectPressed(up,pressedDim) and not isElevatorCarOnFloor(e,f) then
                print("up:e="..e.." f="..f..":",isObjectPressed(up, {x=x,y=y}))
                elevatorButtons[e][dim.f].up = true
                ed = findElevatorGoingUp(f)
                elevatorDest[smartFindElevatorDest(e,ed.e)] = f
                return {e=e,f=f,up=1,num=nil}
            end

            down = elevatorButtonDim(dim.x,dim.y,false)
            if isObjectPressed(down,pressedDim) and not isElevatorCarOnFloor(e,f) then
                print("down:e="..e.." f="..f..":",isObjectPressed(down, {x=x,y=y}))
                elevatorButtons[e][dim.f].down = true
                ed = findElevatorGoingDown(f)
                elevatorDest[smartFindElevatorDest(e, ed.e)] = f
                return {e=e,f=f,up=0,num=nil}
            end
            num = findElevatorFloorLevelIndicatorNum(dim, pressedDim)
            if num > 0 and elevatorCars[e].current ~= num then
                print("num:e="..e.." f="..f..":",num)
                elevatorCars[e].selected[num] = true
                return {e=e,f=f,up=nil,num=num}
            end
        end
    end
    return nil
end
    
function love.mousepressed(x, y, button, istouch)
   if button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      obj = getObjectPressed(x,y)
      if obj ~= nil then
          if obj.num==nil then
              print("button pressed", obj.e, obj.f, obj.up)
              --elevatorDest[obj.e] = obj.f
          else
              print("number pressed")
              elevatorDest[obj.e] = num
          end
      end
   end
end

