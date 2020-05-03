local setup={}
    setup.elevatorWidth = 120
    setup.elevatorHeight = 80
    setup.elevators = 3
    setup.elevatorFloors = 4
    setup.elevatorOffset = 80
    setup.elevatorFirstX = (love.graphics.getWidth()-setup.elevators*setup.elevatorWidth-(setup.elevators-1)*setup.elevatorOffset)/2
    setup.elevatorFirstY = (love.graphics.getHeight()-setup.elevatorHeight*setup.elevatorFloors)/2
    setup.canvasBackColor = {r=142/255, g=209/255, b=1}
    setup.canvasSetColor = {r=1.0, g=158/255, b=50/255}
    setup.elevatorShaftColorFill = {r=255/255, g=160/255, b=122/255}
    setup.elevatorShaftColorBorder = {r=0, g=0, b=0}
    setup.elevatorCarColorFill = {r=0.8, g=0.8, b=0.8}
    setup.elevatorCarColorBorder = {r=0, g=0, b=0}
    setup.elevatorFloorLevelIndicatorHeight = 15
    setup.elevatorFloorLevelIndicatorOffset = 5
    setup.elevatorFloorLevelIndicatorWidth = (setup.elevatorWidth - setup.elevatorFloorLevelIndicatorOffset*2)
    setup.elevatorFloorLevelIndicatorColorBorder = {r=0,g=128/255,b=128/255}
    setup.elevatorFloorLevelIndicatorSelectionColor = {r=255/255,g=165/255,b=0}
    setup.elevatorFloorLevelIndicatorNumWidth = 5
    setup.elevatorFloorLevelIndicatorNumHeight = 5
    setup.elevatorButtonColor = {r=32/255,g=178/255,b=170/255}
    setup.elevatorButtonColorBorder = setup.elevatorShaftColorBorder
    setup.elevatorButtonPressColor = {r=255/255,g=99/255,b=71/255}
    setup.siloMode = false
    if setup.elevators == 1 then
        setup.siloMode = true
    end
    
return setup