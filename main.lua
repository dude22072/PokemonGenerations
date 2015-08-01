require("lib.loveframes")
require('data')

local newGameText = nil
local newGameTextProgress = 0
local currentTextPossition = 0
local textBoxString = {}
local newGameNextButton = nil
local buttonBoy = nil
local buttonGirl = nil
local isPlayerBoy = nil
local playerName = ""
local textPlayerNameInput = nil
local playersprite = nil
local showingPlayerCard = false
local isPlayerSurfing = false
local pleyerFacing = ""
local showingText = false
local Location = 0
local playerBadges = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,}
local buttonUP = 'up'
local buttonDOWN = 'down'
local buttonLEFT = 'left'
local buttonRIGHT = 'right'
local buttonA = 'z'
local buttonB = 'x'
local buttonSTART = 'return'
local selectedOption = 0

local locationsTable = {"Route 1", "Route 2", "Route 3", "Route 4", "Route 5",
"Route 6", "Route 7", "Route 8", "Route 9", "Route 10",
"Route 11", "Route 12", "Route 13", "Route 14", "Route 15",
"Route 16", "Route 17", "Route 18", "Route 19", "Route 20",
"Route 21", "Route 22", "Route 23", "Route 24", "Route 25",
"Route 26", "Route 27", "Route 28", "Route 29", "Route 30",
"Route 31", "Route 32", "Route 33", "Route 34", "Route 35",
"Route 36", "Route 37", "Route 38", "Route 39", "Route 40",
"Route 41", "Route 42", "Route 43", "Route 44", "Route 45",
"Route 46", "Pallet Town", "Viridian City", "Pewter City", "Cerulean City", 
"Saffron City", "Vermilion City", "Celadon City", "Lavender Town", "Fuchsia City", 
"Seafoam Islands", "Cinnabar Island", "Victory Road", "Indigo Plateau", "Viridian Forest", 
"Diglett's Cave", "Mt. Moon", "Rock Tunnel", "S.S. Anne", "Safari Zone", 
"New Bark Town", "Cherrygrove City", "Violet City", "Azalea Town", "Goldenrod City", 
"Ecruteak City", "Olivine City", "Cianwood City", "Mahogany City", "Blackthorn City", 
"Ruins of Alph", "Union Cave", "Ilex Forest", "National Park", "Whirl Islands",
"Mt. Mortar", "Lake of Rage", "Dragon's Den", "Dark Cave", "Silver Cave", }
tile = {}
for i=1,127 do
    tile[i] = love.graphics.newImage( "tiles/resize/Tile"..(i-1)..".png" )
end

local pokemonTeam = {}
local map_w = 470
local map_h = 270
local map_x = 0
local map_y = 0
local map_offset_x = -64
local map_offset_y = -64
local map_display_w = 10
local map_display_h = 9
local tile_w = 64
local tile_h = 64

local player_y = 5
local player_x = 5
   
function love.load(arg)
    loadOptions()
    loveframes.SetState("loaded")
    --State Loaded
    local loadframe = loveframes.Create("frame")
    loadframe:SetName("")
    loadframe:SetPos(0,0)
    loadframe:SetState("loaded")
    loadframe:SetSize(200,200)
    loadframe:ShowCloseButton(false)
    loadframe:SetResizable(false)
    loadframe:SetDraggable(false)
    
    local buttonNewGame = loveframes.Create("button", loadframe)
    buttonNewGame:SetPos(5, 35)
    buttonNewGame:SetText("New Game")
    buttonNewGame.OnClick = function(object)
        loveframes.SetState("newgame")
    end
    
    local buttonLoadGame = loveframes.Create("button", loadframe)
    buttonLoadGame:SetPos(5, 65)
    buttonLoadGame:SetText("Load Game")
    buttonLoadGame.OnClick = function(object)
        loadGame()
    end
    
    local buttonOptions = loveframes.Create("button", loadframe)
    buttonOptions:SetPos(5, 95)
    buttonOptions:SetText("Options")
    buttonOptions.OnClick = function(object)
        optionsMenu(200,0,300,250,"loaded")
    end
    
    local buttonExit = loveframes.Create("button", loadframe)
    buttonExit:SetPos(5, 125)
    buttonExit:SetText("Exit")
    buttonExit.OnClick = function(object)
        os.exit()
    end
    
    --State NewGame
    local newgameframe = loveframes.Create("frame")
    newgameframe:SetName("")
    newgameframe:SetPos(0,0)
    newgameframe:SetState("newgame")
    newgameframe:SetSize(640,576)
    newgameframe:ShowCloseButton(false)
    newgameframe:SetResizable(false)
    newgameframe:SetDraggable(false)
    
    local newgametextframe = loveframes.Create("frame")
    newgametextframe:SetName("")
    newgametextframe:SetPos(0,476)
    newgametextframe:SetState("newgame")
    newgametextframe:SetSize(640,100)
    newgametextframe:ShowCloseButton(false)
    newgametextframe:SetResizable(false)
    newgametextframe:SetDraggable(false)
    newgametextframe:SetAlwaysOnTop(true)
    
    local listNewGameText = loveframes.Create("list", newgametextframe)
    listNewGameText:SetPos(0, 0)
    listNewGameText:SetSize(640, 100)
    listNewGameText:SetPadding(5)
    listNewGameText:SetSpacing(5)
    
    newGameText = loveframes.Create("text")
    newGameText:SetText("Testing")
    listNewGameText:AddItem(newGameText)
    
    newGameNextButton = loveframes.Create("button", newgametextframe)
    newGameNextButton:SetText("Next")
    newGameNextButton:SetPos(555,70)
    newGameNextButton.OnClick = function(object)
        newGameTextProgress = newGameTextProgress + 1
    end
    
    buttonBoy = loveframes.Create("button", newgametextframe)
    buttonGirl = loveframes.Create("button", newgametextframe)
    buttonBoy:SetPos(-500,-500)
    buttonGirl:SetPos(-500,-500)
    
    textPlayerNameInput = loveframes.Create("textinput", newgametextframe)
    textPlayerNameInput:SetPos(-1000,-1000)
    textPlayerNameInput:SetWidth(640)
    
    --State Playing
end

function love.update(dt)
    loveframes.update(dt)
    player_y = map_y + 5
    player_x = map_x + 5
    --State NewGame
    if newGameTextProgress == 0 then
        newGameText:SetText("Hello! Sorry to keep you waiting! Welcome to the world of Pokémon!")
    elseif newGameTextProgress == 1 then
        newGameText:SetText("My name is Professor Acacia. Everyone calls me the Pokémon Professor!")
    elseif newGameTextProgress == 2 then
        newGameText:SetText("This world is inhabitied by creatures that we call Pokémon.")
    elseif newGameTextProgress == 3 then
        newGameText:SetText("People and Pokémon live together by supporting each other. Some people play with pokémon, some battle with them.")
    elseif newGameTextProgress == 4 then
        newGameText:SetText("But we don't know everything about Pokémon yet. There are still many mysteries to solve. That's why I study Pokémon every day.")
    elseif newGameTextProgress == 5 then
        newGameText:SetText("Now... Are you a Boy? Or are you a Girl?")
        newGameNextButton:SetClickable(false)
        buttonBoy:SetPos(555,40)
        buttonGirl:SetPos(555,10)
        buttonBoy:SetText("Boy")
        buttonGirl:SetText("Girl")
        buttonBoy.OnClick = function(object)
            isPlayerBoy = true
            newGameNextButton:SetClickable(true)
            newGameTextProgress = 6
            buttonBoy:Remove()
            buttonGirl:Remove()
        end
        buttonGirl.OnClick = function(object)
            isPlayerBoy = false
            newGameNextButton:SetClickable(true)
            newGameTextProgress = 6
            buttonBoy:Remove()
            buttonGirl:Remove()
        end
        
    elseif newGameTextProgress == 6 then
        if isPlayerBoy == true then
            newGameText:SetText("Of course! You're a handsome young lad!")
        else
            newGameText:SetText("Of course! You're a beautiful young lass!")
        end
    elseif newGameTextProgress == 7 then
        newGameText:SetText("Now, what did you say your name was?\n(Limit 20 characters, press Enter to continue)")
        newGameNextButton:SetClickable(false)
        textPlayerNameInput:SetPos(0,40)
        textPlayerNameInput.OnEnter = function(object, text)
            playerName = text
            textPlayerNameInput:Remove()
            newGameNextButton:SetClickable(true)
            newGameTextProgress = 8
        end
    elseif newGameTextProgress == 8 then
        if isPlayerBoy == true then
            newGameText:SetText(playerName.."? What a cool name!")
        else
            newGameText:SetText(playerName.."? What a cute name!")
        end
    elseif newGameTextProgress == 9 then
        newGameText:SetText(playerName..", are you ready? Your very own Pokémon story is about to unfold.")
    elseif newGameTextProgress == 10 then
        newGameText:SetText("You'll face fun times and tough challenges. A world of dreams and adventures with Pokémon awaits!")
    elseif newGameTextProgress == 11 then
        newGameText:SetText("Let's go! I'll be seeing you later!")
    elseif newGameTextProgress == 12 then
        pokemonTeam = {1,1,1,1,1,1}
        Location = 70
        map_x = 359
        map_y = 218
        loveframes.SetState("playing")
        if isPlayerBoy == true then
            --playersprite = love.graphics.newImage( "sprites/PlayerM1.png" )
        else
            playersprite = love.graphics.newImage( "sprites/PlayerF1.png" )
        end
        newGameTextProgress = 13
    end
    
end

function love.draw()
    drawMap()
    if (loveframes.GetState() == "playing" or loveframes.GetState() == "paused") and playersprite ~= nil then
        love.graphics.draw(playersprite,253,253)
    end
    loveframes.draw()
end

function love.mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
    loveframes.keypressed(key, unicode)
    
    if loveframes.GetState() == "playing" then
        if key == buttonUP then
            if isPlayerBoy == true then
                --playersprite = love.graphics.newImage( "sprites/PlayerM3.png" )
            else
                playersprite = love.graphics.newImage( "sprites/PlayerF3.png" )
            end
            
            pleyerFacing = "up"
            
            if movementData[player_y-1][player_x] == 2 then
                map_y = map_y-1
                if map_y < 0 then map_y = 0; end
            elseif movementData[player_y-1][player_x] == 3 and isPlayerSurfing == true then
                map_y = map_y-1
                if map_y < 0 then map_y = 0; end
            elseif movementData[player_y-1][player_x] == 8 then
                map_y = map_y-1
                if map_y < 0 then map_y = 0; end
                doShouldEncounter()
            elseif movementData[player_y-1][player_x] == 9 then
                tryWarp(player_x,player_y-1)
            end
        end
        if key == buttonDOWN then
            if isPlayerBoy == true then
                --playersprite = love.graphics.newImage( "sprites/PlayerM1.png" )
            else
                playersprite = love.graphics.newImage( "sprites/PlayerF1.png" )
            end
            
            pleyerFacing = "down"
        
            if movementData[player_y+1][player_x] == 2 then
                map_y = map_y+1
                if map_y > map_h-map_display_h then map_y = map_h-map_display_h; end
            elseif movementData[player_y+1][player_x] == 3 and isPlayerSurfing == true then
                map_y = map_y+1
                if map_y > map_h-map_display_h then map_y = map_h-map_display_h; end
            elseif movementData[player_y+1][player_x] == 5 then
                map_y = map_y+2
                if map_y > map_h-map_display_h then map_y = map_h-map_display_h; end
            elseif movementData[player_y+1][player_x] == 8 then
                map_y = map_y+1
                if map_y > map_h-map_display_h then map_y = map_h-map_display_h; end
                doShouldEncounter()
            elseif movementData[player_y+1][player_x] == 9 then
                tryWarp(player_x,player_y+1)
            end
        end
        if key == buttonLEFT then
            if isPlayerBoy == true then
                --playersprite = love.graphics.newImage( "sprites/PlayerM2.png" )
            else
                playersprite = love.graphics.newImage( "sprites/PlayerF2.png" )
            end
            
            pleyerFacing = "left"
            
            if movementData[player_y][player_x-1] == 2 then
                map_x = math.max(map_x-1, 0)
            elseif movementData[player_y][player_x-1] == 3 and isPlayerSurfing == true then
                map_x = math.max(map_x-1, 0)
            elseif movementData[player_y][player_x-1] == 4 then
                map_x = math.max(map_x-2, 0)
            elseif movementData[player_y][player_x-1] == 8 then
                map_x = math.max(map_x-1, 0)
                doShouldEncounter()
            elseif movementData[player_y][player_x-1] == 9 then
                tryWarp(player_x-1,player_y)
            end
        end
        if key == buttonRIGHT then
            if isPlayerBoy == true then
                --playersprite = love.graphics.newImage( "sprites/PlayerM4.png" )
            else
                playersprite = love.graphics.newImage( "sprites/PlayerF4.png" )
            end
            
            pleyerFacing = "right"
            
            if movementData[player_y][player_x+1] == 2 then
                map_x = math.min(map_x+1, map_w-map_display_w)
            elseif movementData[player_y][player_x+1] == 3 and isPlayerSurfing == true then
                map_x = math.min(map_x+1, map_w-map_display_w)
            elseif movementData[player_y][player_x+1] == 6 then
                map_x = math.min(map_x+2, map_w-map_display_w)
            elseif movementData[player_y][player_x+1] == 8 then
                map_x = math.min(map_x+1, map_w-map_display_w)
                doShouldEncounter()
            elseif movementData[player_y][player_x+1] == 9 then
                tryWarp(player_x+1,player_y)
            end
        end
        
        if key == buttonA then
            if showingText == true then
                NextTextButtonOnClick()
            else
                if pleyerFacing == "up" then
                    tryEvent(player_x,player_y-1)
                elseif pleyerFacing == "down" then
                    tryEvent(player_x,player_y+1)
                elseif pleyerFacing == "left" then
                    tryEvent(player_x-1,player_y)
                elseif pleyerFacing == "right" then
                    tryEvent(player_x+1,player_y)
                end
            end
        end
        if key == buttonB then
            if showingText == true then
                NextTextButtonOnClick()
            else
            
            end
        end
        
        if key == buttonSTART then
            loveframes.SetState("paused")
            showStartMenu()
        end
    elseif loveframes.GetState() == "paused" then
        --
    elseif loveframes.GetState() == "battle" then
        if isSelectingMove ~= true then
            if key == buttonUP then
                if selectedOption == 2 then
                    imageBattleSelArrow:SetPos(15,55)
                    selectedOption = 0
                elseif selectedOption == 3 then
                    imageBattleSelArrow:SetPos(215,55)
                    selectedOption = 1
                end
            end
            if key == buttonDOWN then
                if selectedOption == 0 then
                    imageBattleSelArrow:SetPos(15,115)
                    selectedOption = 2
                elseif selectedOption == 1 then
                    imageBattleSelArrow:SetPos(215,115)
                    selectedOption = 3
                end
            end
            if key == buttonLEFT then
                if selectedOption == 1 then
                    imageBattleSelArrow:SetPos(15,55)
                    selectedOption = 0
                elseif selectedOption == 3 then
                    imageBattleSelArrow:SetPos(15,115)
                    selectedOption = 2
                end
            end
            if key == buttonRIGHT then
                if selectedOption == 0 then
                    imageBattleSelArrow:SetPos(215,55)
                    selectedOption = 1
                elseif selectedOption == 2 then
                    imageBattleSelArrow:SetPos(215,115)
                    selectedOption = 3
                end
            end
            
            if key == buttonA then
                if selectedOption == 0 then
                    buttonFight:OnClick()
                elseif selectedOption == 1 then
                    buttonPokemon:OnClick()
                elseif selectedOption == 2 then
                    buttonPack:OnClick()
                elseif selectedOption == 3 then
                    buttonRun:OnClick()
                end
            end
        else
            --SelectingMove
        end
    end
end

function love.keyreleased(key)
    loveframes.keyreleased(key)
end

function love.textinput(text)
    loveframes.textinput(text)
end

function drawMap()
    if loveframes.GetState() == "playing" or loveframes.GetState() == "paused" then
        for y=1, map_display_h do
            for x=1, map_display_w do                                                         
                love.graphics.draw( 
                    tile[map[y+map_y][x+map_x]], 
                    (x*tile_w)+map_offset_x, 
                    (y*tile_h)+map_offset_y )
            end
        end
   end
end

function showStartMenu()
    local menuFrame = loveframes.Create("frame")
    menuFrame:SetName("")
    menuFrame:SetPos(440,0)
    menuFrame:SetState("paused")
    menuFrame:SetSize(200,576)
    menuFrame:ShowCloseButton(false)
    menuFrame:SetResizable(false)
    menuFrame:SetDraggable(false)
    
    local buttonPokedex = loveframes.Create("button", menuFrame)
    buttonPokedex:SetPos(5, 35)
    buttonPokedex:SetWidth(190)
    buttonPokedex:SetText("Pokédex")
    buttonPokedex.OnClick = function(object)
        --
    end
    
    local buttonPokemon = loveframes.Create("button", menuFrame)
    buttonPokemon:SetPos(5, 65)
    buttonPokemon:SetWidth(190)
    buttonPokemon:SetText("Pokémon")
    buttonPokemon.OnClick = function(object)
        --
    end
    
    local buttonBag = loveframes.Create("button", menuFrame)
    buttonBag:SetPos(5, 95)
    buttonBag:SetWidth(190)
    buttonBag:SetText("Bag")
    buttonBag.OnClick = function(object)
        --
    end
    
    local buttonPokegear = loveframes.Create("button", menuFrame)
    buttonPokegear:SetPos(5, 125)
    buttonPokegear:SetWidth(190)
    buttonPokegear:SetText("Pokégear")
    buttonPokegear.OnClick = function(object)
        --
    end
    
    local buttonTrainer = loveframes.Create("button", menuFrame)
    buttonTrainer:SetPos(5, 155)
    buttonTrainer:SetWidth(190)
    buttonTrainer:SetText(playerName)
    buttonTrainer.OnClick = function(object)
        showPlayerCard(menuFrame)
    end
    
    local buttonSave = loveframes.Create("button", menuFrame)
    buttonSave:SetPos(5, 185)
    buttonSave:SetWidth(190)
    buttonSave:SetText("Save")
    buttonSave.OnClick = function(object)
        showSaveMenu()
    end
    
    local buttonOptions = loveframes.Create("button", menuFrame)
    buttonOptions:SetPos(5, 215)
    buttonOptions:SetWidth(190)
    buttonOptions:SetText("Options")
    buttonOptions.OnClick = function(object)
        optionsMenu(0,0,300,250,"paused")
    end
    
    local buttonClose = loveframes.Create("button", menuFrame)
    buttonClose:SetPos(5, 245)
    buttonClose:SetWidth(190)
    buttonClose:SetText("Close")
    buttonClose.OnClick = function(object)
        loveframes.SetState("playing")
        menuFrame:Remove()
    end
    
    local buttonDebug = loveframes.Create("button", menuFrame)
    buttonDebug:SetPos(5, 545)
    buttonDebug:SetWidth(190)
    buttonDebug:SetText("Debug")
    buttonDebug.OnClick = function(object)
        local debugFrame = loveframes.Create("frame")
        debugFrame:SetName("Debug")
        debugFrame:SetPos(0,0)
        debugFrame:SetState("paused")
        debugFrame:SetSize(300,250)
        debugFrame:SetAlwaysOnTop(true)
        debugFrame:ShowCloseButton(true)
        debugFrame:SetResizable(false)
        debugFrame:SetDraggable(false)
        
        local buttonWalkEverywhere = loveframes.Create("button", debugFrame)
        buttonWalkEverywhere:SetPos(10,30):SetText("Walk Through Walls")
        buttonWalkEverywhere.OnClick = function(object)
            for Y=1,map_h do
                for X=1,map_w do
                    if movementData[Y][X] ~= 9 then
                        movementData[Y][X] = 2
                    end
                end
            end
        end
        
        local buttonTestEncounter = loveframes.Create("button", debugFrame)
        buttonTestEncounter:SetPos(10, 70):SetText("Test Encounter")
        buttonTestEncounter.OnClick = function(object)
            pokemonTeam[1] = {1, "bulba", 5, 10, 20, 0, 
            0, 0, 0, 0,
            1, 35, 0,
            0, 0, 0,
            0, 0, 0,
            0, 0, 0,
            playerName, 00000, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 
            0, 0, 0, 0, 0, 0,
            {0,0,0,0}
            }
            
            doEncounter({
            {25, "Pikachu", 5, 20, 20, 0, 0, 0, 0, 0, 2, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, nil, nil, 0, nil, nil, nil, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, {0,0,0,0}},
            {},
            {},
            {},
            {},
            {}
            })
        end
        
    end
    
end

function optionsMenu(x,y,sx,sy,state)
        local optionsFrame = loveframes.Create("frame")
        optionsFrame:SetName("Options")
        optionsFrame:SetPos(x,y)
        optionsFrame:SetState(state)
        optionsFrame:SetSize(sx,sy)
        optionsFrame:SetAlwaysOnTop(true)
        optionsFrame:ShowCloseButton(true)
        optionsFrame:SetResizable(false)
        optionsFrame:SetDraggable(false)
        
        local listOptions = loveframes.Create("list", optionsFrame)
        listOptions:SetPos(0, 0)
        listOptions:SetSize(300, 210)
        listOptions:SetPadding(5)
        listOptions:SetSpacing(5)
        
        local textA = loveframes.Create("text")
        textA:SetText("CONTROLS:\n    Up:\n    Down:\n    Left:\n    Right:\n    A:\n    B:\n    Start:")
        listOptions:AddItem(textA)
        
        local textinputUP = loveframes.Create("textinput", optionsFrame)
        textinputUP:SetPos(60, 20)
        textinputUP:SetSize(40, 15)
        textinputUP:SetText(buttonUP)
        
        local textinputDOWN = loveframes.Create("textinput", optionsFrame)
        textinputDOWN:SetPos(60, 35)
        textinputDOWN:SetSize(40, 15)
        textinputDOWN:SetText(buttonDOWN)
        
        local textinputLEFT = loveframes.Create("textinput", optionsFrame)
        textinputLEFT:SetPos(60, 50)
        textinputLEFT:SetSize(40, 15)
        textinputLEFT:SetText(buttonLEFT)
        
        local textinputRIGHT = loveframes.Create("textinput", optionsFrame)
        textinputRIGHT:SetPos(60, 65)
        textinputRIGHT:SetSize(40, 15)
        textinputRIGHT:SetText(buttonRIGHT)
        
        local textinputA = loveframes.Create("textinput", optionsFrame)
        textinputA:SetPos(60, 80)
        textinputA:SetSize(40, 15)
        textinputA:SetText(buttonA)
        
        local textinputB = loveframes.Create("textinput", optionsFrame)
        textinputB:SetPos(60, 95)
        textinputB:SetSize(40, 15)
        textinputB:SetText(buttonB)
        
        local textinputSTART = loveframes.Create("textinput", optionsFrame)
        textinputSTART:SetPos(60, 110)
        textinputSTART:SetSize(40, 15)
        textinputSTART:SetText(buttonSTART)
        
        local buttonSaveOptions = loveframes.Create("button", optionsFrame)
        buttonSaveOptions:SetPos(215, 220)
        buttonSaveOptions:SetText("Save")
        buttonSaveOptions.OnClick = function(object)
            buttonUP = textinputUP:GetText()
            buttonDOWN = textinputDOWN:GetText()
            buttonLEFT = textinputLEFT:GetText()
            buttonRIGHT = textinputRIGHT:GetText()
            buttonA = textinputA:GetText()
            buttonB = textinputB:GetText()
            buttonSTART = textinputSTART:GetText()
            saveOptions()
            optionsFrame:Remove()
        end
        
        local buttonExitOptions = loveframes.Create("button", optionsFrame)
        buttonExitOptions:SetPos(5, 220)
        buttonExitOptions:SetText("Back")
        buttonExitOptions.OnClick = function(object)
            optionsFrame:Remove()
        end
end

function showSaveMenu()
    saveGame()
    displayTextBox({"Saved"})
end

function showPlayerCard(menuFrame)
    local trainerCardFrame = loveframes.Create("frame")
    trainerCardFrame:SetName("")
    trainerCardFrame:SetPos(0,0)
    trainerCardFrame:SetState("paused")
    trainerCardFrame:SetSize(200,480)
    trainerCardFrame:ShowCloseButton(false)
    trainerCardFrame:SetResizable(false)
    trainerCardFrame:SetDraggable(false)
    
    local trainerCardImage = loveframes.Create("image", trainerCardFrame)
    trainerCardImage:SetImage(love.graphics.newImage("/other/trainerCard.png"))
    trainerCardImage:SetPos(0, 0)
    
    local boulderBadge = loveframes.Create("image", trainerCardFrame)
    boulderBadge:SetImage(love.graphics.newImage("other/badges/boulderBadge.png"))
    boulderBadge:SetPos(-100,-100)
    
    local cascadeBadge = loveframes.Create("image", trainerCardFrame)
    cascadeBadge:SetImage(love.graphics.newImage("other/badges/cascadeBadge.png"))
    cascadeBadge:SetPos(-100,-100)
    
    local thunderBadge = loveframes.Create("image", trainerCardFrame)
    thunderBadge:SetImage(love.graphics.newImage("other/badges/thunderBadge.png"))
    thunderBadge:SetPos(-100,-100)
    
    local rainbowBadge = loveframes.Create("image", trainerCardFrame)
    rainbowBadge:SetImage(love.graphics.newImage("other/badges/rainbowBadge.png"))
    rainbowBadge:SetPos(-100,-100)
    
    local soulBadge = loveframes.Create("image", trainerCardFrame)
    soulBadge:SetImage(love.graphics.newImage("other/badges/soulBadge.png"))
    soulBadge:SetPos(-100,-100)
    
    local marshBadge = loveframes.Create("image", trainerCardFrame)
    marshBadge:SetImage(love.graphics.newImage("other/badges/marshBadge.png"))
    marshBadge:SetPos(-100,-100)
    
    local volcanoBadge = loveframes.Create("image", trainerCardFrame)
    volcanoBadge:SetImage(love.graphics.newImage("other/badges/volcanoBadge.png"))
    volcanoBadge:SetPos(-100,-100)
    
    local earthBadge = loveframes.Create("image", trainerCardFrame)
    earthBadge:SetImage(love.graphics.newImage("other/badges/earthBadge.png"))
    earthBadge:SetPos(-100,-100)
    
    local buttonBadges = loveframes.Create("button", trainerCardFrame)
    buttonBadges:SetPos(520, 515)
    buttonBadges:SetText("Badges")
    buttonBadges.OnClick = function(object)
        trainerCardImage:SetPos(0, -544)
        if playerBadges[1] == 1 then
            boulderBadge:SetPos(36,60)
        end
        if playerBadges[2] == 1 then
            cascadeBadge:SetPos(108,60)
        end
        if playerBadges[3] == 1 then
            thunderBadge:SetPos(172,60)
        end
        if playerBadges[4] == 1 then
            rainbowBadge:SetPos(244,60)
        end
        if playerBadges[5] == 1 then
            soulBadge:SetPos(316,60)
        end
        if playerBadges[6] == 1 then
            marshBadge:SetPos(392,60)
        end
        if playerBadges[7] == 1 then
            volcanoBadge:SetPos(468,60)
        end
        if playerBadges[8] == 1 then
            earthBadge:SetPos(540,60)
        end
        
        local buttonExitTC = loveframes.Create("button", trainerCardFrame)
        buttonExitTC:SetPos(520, 515)
        buttonExitTC:SetText("Exit")
        buttonExitTC.OnClick = function(object)
            trainerCardFrame:Remove()
        end
        buttonBadges:Remove()
    end
    
    
    
end

function doShouldEncounter()
    --
end

function tryWarp(fromX,fromY)
    if fromX == 364 and fromY == 222 then
        print("Player House")
    elseif fromX == 357 and fromY == 220 then
        print("Professor Elm's Place")
    elseif fromX == 354 and fromY == 228 then
        print("New Bark Town House 1")
    elseif fromX == 362 and fromY == 230 then
        print("New Bark Town House 2")
    elseif fromX == 319 and fromY == 218 then
        print("Route 29 and Route 46")
    elseif fromX == 281 and fromY == 220 then
        print("Cherrygrove Pokemon Centre")
    elseif fromX == 275 and fromY == 220 then
        print("Cherrygrove Pokemart")
    elseif fromX == 269 and fromY == 224 then
        print("Cherrygrove House 1")
    elseif fromX == 277 and fromY == 226 then
        print("Cherrygrove House 2")
    elseif fromX == 283 and fromY == 228 then
        print("Cherrygrove House 3")
    elseif fromX == 269 and fromY == 202 then
        print("Route 30 House")
    elseif fromX == 279 and fromY == 168 then
        print("Mr. Pokemon House")
    elseif fromX == 276 and fromY == 150 then
        print("Route 31 Dark Cave")
    elseif fromX == 245 and (fromY == 151 or fromY == 152) then --Needs actually thing
        print("Route 31 to Violet")
        map_x = math.max(map_x-6, 0)
    elseif fromX == 242 and (fromY == 151 or fromY == 152) then --Needs actually thing
        print("Violet to Route 31")
        map_x = math.max(map_x+6, 0)
    elseif fromX == 233 and fromY == 152 then
        print("Violet City Pokemon Centre")
    elseif fromX == 211 and fromY == 144 then
        print("Violet City Pokemart")
    elseif fromX == 220 and fromY == 144 then
        print("Violet City Pokemon Gym")
    elseif fromX == 225 and fromY == 132 then
        print("Violet City Sprout Tower")
    elseif fromX == 223 and fromY == 156 then
        print("Violet City House 1")
    elseif fromX == 232 and fromY == 144 then
        print("Violet City House 2")
    elseif fromX == 205 and fromY == 142 then
        print("Violet City House 3")
    elseif (fromX == 189 or fromX == 190) and fromY == 141 then
        print("Ruins of Alph - North Entrance")
    elseif fromX == 205 and (fromY == 165 or fromY == 166) then
        print("Ruins of Alph - East Entrance")
    elseif fromX == 213 and fromY == 236 then
        print("Route 32 Pokemon Centre")
    elseif fromX == 208 and fromY == 242 then
        print("Route 32 to Union Cave")
        
        
    else
        print("Unknown warp! X:"..fromX.." Y:"..fromY)
    end
end

function tryEvent(fromX,fromY)

    if movementData[fromY][fromX] == 3 then
        print("Surfable Tile")
    elseif movementData[fromY][fromX] == 7 then
        print("Cutable Tile")
    elseif fromX == 362 and fromY == 222 then
        displayTextBox({playerName.."'s House"})
    elseif fromX == 354 and fromY == 220 then
        displayTextBox({"Elm Pokémon Lab"})
    elseif fromX == 360 and fromY == 230 then
        displayTextBox({"Elm's House"})
    elseif fromX == 359 and fromY == 225 then
        displayTextBox({"New Bark Town", "The town where the winds of a new beginning blow."})


    else
        print("Event non-existent or failed! X:"..fromX.." Y:"..fromY)
    end
end

function displayTextBox(inputStringArray)
    showingText = true
    textBoxString = inputStringArray
    currentTextPossition = 1
    
    textFrame = loveframes.Create("frame")
    textFrame:SetName("")
    textFrame:SetPos(0,476)
    textFrame:SetSize(640,100)
    textFrame:SetState("playing")
    textFrame:ShowCloseButton(false)
    textFrame:SetResizable(false)
    textFrame:SetDraggable(false)
    
    listText = loveframes.Create("list", textFrame)
    listText:SetPos(0, 0)
    listText:SetSize(640, 100)
    listText:SetPadding(5)
    listText:SetSpacing(5)
    
    TextBox = loveframes.Create("text")
    TextBox:SetText(textBoxString[currentTextPossition])
    listText:AddItem(TextBox)
    
    NextTextButton = loveframes.Create("button", textFrame)
    if textBoxString[(currentTextPossition + 1)] ~= nil then
        NextTextButton:SetText("Next")
    else
        NextTextButton:SetText("Close")
    end
    NextTextButton:SetPos(555,70)
    NextTextButton.OnClick = function(object)
        NextTextButtonOnClick()
    end
end

function NextTextButtonOnClick()
        if textBoxString[(currentTextPossition + 1)] ~= nil then
            currentTextPossition = currentTextPossition + 1
            TextBox:SetText(textBoxString[currentTextPossition])
            if textBoxString[(currentTextPossition + 1)] ~= nil then
                NextTextButton:SetText("Next")
            else
                NextTextButton:SetText("Close")
            end
        else
            showingText = false
            textFrame:Remove()
        end
end

function saveGame()
    if not love.filesystem.exists('gameSave.txt') then
        fileOptions = love.filesystem.newFile('gameSave.txt')      
    end
    
    local genderStatus = ""
    if isPlayerBoy == true then
        genderStatus = "true"
    else
        genderStatus = "false"
    end
    
    local surfStatus = ""
    if isPlayerSurfing == true then
        surfStatus = "true"
    else
        surfStatus = "false"
    end
    
    local badgeData=""
    for I = 1,43 do
        badgeData = badgeData..playerBadges[I]..'\n'
    end
    
    love.filesystem.write('gameSave.txt', playerName..'\n'..genderStatus..'\n'..map_x..'\n'..map_y..'\n'..surfStatus..'\n'..Location..'\n'..badgeData--[[..nextThing]]) 
end

function loadGame()
    loadFile = {}
    if love.filesystem.exists('gameSave.txt') then
        for lines in love.filesystem.lines('gameSave.txt') do
            table.insert(loadFile, lines) 
        end
        
        playerName = loadFile[1]
        if loadFile[2] == "true" then
            isPlayerBoy = true
        else
            isPlayerBoy = false
        end
        map_x = loadFile[3]
        map_y = loadFile[4]
        if loadFile[5] == "true" then
            isPlayerSurfing = true
        else
            isPlayerSurfing = false
        end
        Location = loadFile[6]
        for I = 1,43 do
            playerBadges[I] = loadFile[(6+I)]
        end
        
        loveframes.SetState("playing")
    end
end

function saveOptions()
    if not love.filesystem.exists('optionsSave.txt') then
        fileOptions = love.filesystem.newFile('optionsSave.txt')      
    end
    love.filesystem.write('optionsSave.txt', buttonUP..'\n'..buttonDOWN..'\n'..buttonLEFT..'\n'..buttonRIGHT..'\n'..buttonA..'\n'..buttonB..'\n'..buttonSTART) 
end

function loadOptions()
    loadFile = {}
    if love.filesystem.exists('optionsSave.txt') then
        for lines in love.filesystem.lines('optionsSave.txt') do
            table.insert(loadFile, lines) 
        end
        
        buttonUP = loadFile[1]
        buttonDOWN = loadFile[2]
        buttonLEFT = loadFile[3]
        buttonRIGHT = loadFile[4]
        buttonA = loadFile[5]
        buttonB = loadFile[6]
        buttonSTART = loadFile[7]
        
    end
end

function doEncounter(enemyTeam)
    loveframes.SetState("battle")
    local frameBattle = loveframes.Create("frame")
    frameBattle:SetName("")
    frameBattle:SetPos(0,0)
    frameBattle:SetState("battle")
    frameBattle:SetSize(640,576)
    frameBattle:ShowCloseButton(false)
    frameBattle:SetResizable(false)
    frameBattle:SetDraggable(false)

    imageEnemyPokemon = loveframes.Create("image", frameBattle)
    imageEnemyPokemon:SetImage(love.graphics.newImage("sprites/pokemon/"..pokemonTable[(enemyTeam[1][1] + 1)]..".png"))
    imageEnemyPokemon:SetPos(400,0)
    
    imagePlayerPokemon = loveframes.Create("image", frameBattle)
    imagePlayerPokemon:SetImage(love.graphics.newImage("sprites/pokemon/back/"..pokemonTable[(pokemonTeam[1][1] + 1)]..".png"))
    imagePlayerPokemon:SetPos(36,160)
    
    frameBattleText = loveframes.Create("frame", frameBattle)
    frameBattleText:SetName("")
    frameBattleText:SetPos(0,396)
    frameBattleText:SetState("battle")
    frameBattleText:SetSize(640,180)
    frameBattleText:ShowCloseButton(false)
    frameBattleText:SetResizable(false)
    frameBattleText:SetDraggable(false)
    
    ----
    
    frameBattleSelection = loveframes.Create("frame", frameBattleText)
    frameBattleSelection:SetName("")
    frameBattleSelection:SetPos(260,0)
    frameBattleSelection:SetState("battle")
    frameBattleSelection:SetSize(380,180)
    frameBattleSelection:ShowCloseButton(false)
    frameBattleSelection:SetResizable(false)
    frameBattleSelection:SetDraggable(false)
    
    buttonFight = loveframes.Create("button", frameBattleSelection)
    buttonFight:SetText("FIGHT"):SetSize(160, 60):SetPos(40,40)
    buttonFight.OnMouseEnter = function(object)
        imageBattleSelArrow:SetPos(15,55)
        selectedOption = 0
    end
    buttonFight.OnClick = function(object)
        isSelectingMove = true
        print("buttonFight")
    end
    
    buttonPack = loveframes.Create("button", frameBattleSelection)
    buttonPack:SetText("PACK"):SetSize(160, 60):SetPos(40, 100)
    buttonPack.OnMouseEnter = function(object)
        imageBattleSelArrow:SetPos(15,115)
        selectedOption = 2
    end
    buttonPack.OnClick = function(object)
        print("buttonPack")
    end
    
    buttonPokemon = loveframes.Create("button", frameBattleSelection)
    buttonPokemon:SetText("PkMn"):SetSize(130, 60):SetPos(240, 40)
    buttonPokemon.OnMouseEnter = function(object)
        imageBattleSelArrow:SetPos(215,55)
        selectedOption = 1
    end
    buttonPokemon.OnClick = function(object)
        print("buttonPokemon")
    end
    
    buttonRun = loveframes.Create("button", frameBattleSelection)
    buttonRun:SetText("RUN"):SetSize(130, 60):SetPos(240, 100)
    buttonRun.OnMouseEnter = function(object)
        imageBattleSelArrow:SetPos(215,115)
        selectedOption = 3
    end
    buttonRun.OnClick = function(object)
        print("buttonRun")
    end
    
    imageBattleSelArrow = loveframes.Create("image", frameBattleSelection)
    imageBattleSelArrow:SetImage(love.graphics.newImage("other/arrow.png"))
    imageBattleSelArrow:SetPos(15,55) --Fight: (15,55), Pack: (15,115), PkMn: (215,55), Run: (215,115)
    
    
end