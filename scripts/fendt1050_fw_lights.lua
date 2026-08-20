-- Fendt 1050 Feuerwehr - Blaulicht und Martinshorn Script
-- Version 1.0

local Fendt1050FW = {}

function Fendt1050FW:load(vehicle)
    self.vehicle = vehicle
    self.blaulichtActive = false
    self.martinshornActive = false
    self.blinkTime = 0
    self.blinkPattern = {0.15, 0.15, 0.15, 0.35} -- Blinkmuster
    self.patternIndex = 1
    
    -- Lichter initialisieren
    self.lightLeft = vehicle:getChildNode("lightNode_01")
    self.lightRight = vehicle:getChildNode("lightNode_02")
    
    print("Fendt 1050 Feuerwehr: Blaulicht und Martinshorn geladen!")
end

function Fendt1050FW:update(dt)
    if self.blaulichtActive then
        self:updateBlaulicht(dt)
    end
end

function Fendt1050FW:updateBlaulicht(dt)
    self.blinkTime = self.blinkTime + dt
    
    if self.blinkTime >= self.blinkPattern[self.patternIndex] then
        self.blinkTime = 0
        self.patternIndex = self.patternIndex + 1
        
        if self.patternIndex > #self.blinkPattern then
            self.patternIndex = 1
        end
        
        -- Lichter ein/ausschalten basierend auf Pattern
        local isOn = (self.patternIndex == 1 or self.patternIndex == 3)
        self:setLightIntensity(isOn and 2.5 or 0)
    end
end

function Fendt1050FW:setLightIntensity(intensity)
    if self.lightLeft then
        self.lightLeft:setIntensity(intensity)
    end
    if self.lightRight then
        self.lightRight:setIntensity(intensity)
    end
end

function Fendt1050FW:toggleBlaulicht()
    self.blaulichtActive = not self.blaulichtActive
    
    if not self.blaulichtActive then
        self:setLightIntensity(0)
    end
    
    print("Blaulicht: " .. (self.blaulichtActive and "AN" or "AUS"))
end

function Fendt1050FW:toggleMartinshorn()
    self.martinshornActive = not self.martinshornActive
    print("Martinshorn: " .. (self.martinshornActive and "AN" or "AUS"))
    
    if self.martinshornActive then
        -- Sound abspielen
        if self.vehicle:playSound("martinshorn") then
            print("Martinshorn Sound wird abgespielt")
        end
    else
        -- Sound stoppen
        self.vehicle:stopSound("martinshorn")
    end
end

return Fendt1050FW
