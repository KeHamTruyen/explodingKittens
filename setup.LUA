
revealingTopThree = false
topThreeCardsGUID = {nil, nil, nil}
seeTheFuturePlayerColour = nil
seeTheFutureTimer = os.time() - 10.0
drawStartTimer = os.time() - 15.0
drawCardTimer = os.time()
insertExplodingTimer = os.time()
shuffleHandTimer = os.time()
seeTheFutureTimer2 = os.time()
updateTimer = os.time()
updateTimer2 = os.time()

table = nil
deck_zone = nil
defuse_zone = nil
exploding_zone = nil
inputs = {}

function onLoad()
    table = getObjectFromGUID('91f1b9')
    deck_zone = getObjectFromGUID('c130e4')
    defuse_zone = getObjectFromGUID('849ae6')
    exploding_zone = getObjectFromGUID('0a829d')
    
    local button = {}
    button.click_function = 'drawCards'
    button.label = 'Draw / Start'
    button.position = {-1.0, 0.6, 2.0}
    button.rotation = {0, 0, 0}
    button.width = 750
    button.height = 200
    button.font_size = 100
    button.tooltip = 'Draw / Start'
    table.createButton(button)

    local button = {}
    button.click_function = 'doShuffle'
    button.label = 'Shuffle Hand'
    button.position = {1.0, 0.6, 2.0}
    button.rotation = {0, 0, 0}
    button.width = 750
    button.height = 200
    button.font_size = 100
    button.tooltip = 'Shuffle Hand'
    table.createButton(button)

    local button = {}
    button.click_function = 'insertExploding'
    button.label = 'Insert Exploding'
    button.position = {1.0, 0.6, -2.0}
    button.rotation = {0, 0, 0}
    button.width = 750
    button.height = 200
    button.font_size = 100
    button.tooltip = 'Insert Exploding'
    table.createButton(button)

    local button = {}
    button.click_function = 'seeFuture'
    button.label = 'See The Future'
    button.position = {-1.0, 0.6, -2.0}
    button.rotation = {0, 0, 0}
    button.width = 750
    button.height = 200
    button.font_size = 100
    button.tooltip = 'See The Future'
    table.createButton(button)

    local button = {}
    button.click_function = 'switchSpectator'
    button.label = 'Spectator'
    button.position = {0.0, 0.0, -50.0}
    button.rotation = {0, 0.0, 0}
    button.width = 2000
    button.height = 500
    button.font_size = 250
    button.tooltip = 'Spectator'
    table.createButton(button)
end

function onUpdate()
    if os.time() - updateTimer > 0.0 then
        updateTimer = os.time() + 1.0
        --print(math.random(100))
    end

    if os.time() - updateTimer2 > 0.0 then
        updateTimer2 = os.time() + 0.1
        if table ~= nil then
            local buttons = table.getButtons()
            --if buttons ~= nil and tablelength(buttons) == 5 then
            if buttons ~= nil then
                for index, button in ipairs(buttons) do
                    local position = button.position
                    if button.tooltip == 'Draw / Start' then
                        if (os.time() - drawStartTimer) > 0.0 and (os.time() - drawCardTimer) > 0 then
                            if position.y > 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y - 100.0, position.z}})
                            end
                        else
                            if position.y < 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y + 100.0, position.z}})
                            end
                        end

                        local isDraw = false
                        local seatedPlayers = getSeatedPlayers()
                        for _, playerColor in ipairs(seatedPlayers) do
                            local handObjects = Player[playerColor].getHandObjects()
                            if tablelength(handObjects) > 0 then
                                isDraw = true
                                break
                            end
                        end
                        
                        if not isDraw then
                            if button.label ~= 'Start' then
                                table.editButton({index = index - 1, label = 'Start'})
                            end
                        else
                            if button.label ~= 'Draw' then
                                table.editButton({index = index - 1, label = 'Draw'})
                            end
                        end
                    elseif button.tooltip == 'Shuffle Hand' then
                        if (os.time() - shuffleHandTimer) > 0 then
                            if position.y > 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y - 100.0, position.z}})
                            end
                        else
                            if position.y < 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y + 100.0, position.z}})
                            end
                        end
                    elseif button.tooltip == 'Insert Exploding' then
                        if (os.time() - insertExplodingTimer) > 0 then
                            if position.y > 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y - 100.0, position.z}})
                            end
                        else
                            if position.y < 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y + 100.0, position.z}})
                            end
                        end
                    elseif button.tooltip == 'See The Future' then
                        if (os.time() - seeTheFutureTimer) > 0.0 and (os.time() - seeTheFutureTimer2) > 0 then
                            if position.y > 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y - 100.0, position.z}})
                            end
                        else
                            if position.y < 100.0 then
                                table.editButton({index = index - 1, position = {position.x, position.y + 100.0, position.z}})
                            end
                        end
                    end
                end
            end
        end


        --print(math.random(100))
    end
end

function drawCards(objectButtonClicked, playerColorClicked)
    
    local isDraw = false
    local seatedPlayers = getSeatedPlayers()
    for _, playerColor in ipairs(seatedPlayers) do
        local handObjects = Player[playerColor].getHandObjects()
        if tablelength(handObjects) > 0 then
            isDraw = true
            break
        end
    end
    
    if not isDraw then
        if (os.time() - drawStartTimer) > 0 then

            drawStartTimer = os.time() + 15.0

            seeTheFutureTimer = os.time() + 15.0
            insertExplodingTimer = os.time() + 15.0
            shuffleHandTimer = os.time() + 15.0

            local cntShuffle = math.random(3, 6)
            local cntShuffle2 = math.random(3, 6)
            local objects = self.getObjects()
            for _,obj in ipairs(objects) do
                if obj.name == 'Card' then
                    if obj.getDescription() == 'exploding' then
                        obj.setRotationSmooth({0.0, 0.0, 0.0})
                        obj.setPositionSmooth({-10.0, 5.0, 0})
                    elseif obj.getDescription() == 'defuse' then
                        obj.setRotationSmooth({0.0, 0.0, 0.0})
                        obj.setPositionSmooth({10.0, 5.0, 0})
                    else
                        obj.setRotationSmooth({0.0, 0.0, 0.0})
                        obj.setPositionSmooth({0, 5.0, 0})
                    end

                elseif obj.name == 'Deck' then
                    local cards = obj.getObjects()
                    local cardsCnt = tablelength(cards)
                    if cardsCnt > 0 then
                        for j = cardsCnt - 1, 0, -1 do
                            obj.takeObject({
                                callback_function = function(spawnedObject)
                                    if spawnedObject.getDescription() == 'exploding' then
                                        spawnedObject.setRotationSmooth({0.0, 0.0, 0.0})
                                        spawnedObject.setPositionSmooth({-10.0, 5.0, 0})
                                    elseif spawnedObject.getDescription() == 'defuse' then
                                        spawnedObject.setRotationSmooth({0.0, 0.0, 0.0})
                                        spawnedObject.setPositionSmooth({10.0, 5.0, 0})
                                    else
                                        spawnedObject.setRotationSmooth({0.0, 0.0, 0.0})
                                        spawnedObject.setPositionSmooth({0, 5.0, 0})
                                    end
                                end,
                                smooth = false,
                                index = j,
                            })
                        end
                    end
                end
            end

            Wait.time(function ()
                local decksCnt = 0
                local objects = self.getObjects()
                for _,obj in ipairs(objects) do
                    if obj.name == 'Deck' then
                        decksCnt = decksCnt + 1
                    end
                end
                if decksCnt == 3 then
                    for _,obj in ipairs(defuse_zone.getObjects()) do
                        if obj.name == 'Deck' then
                            obj.shuffle()
                            Wait.time(function ()
                                obj.dealToAll(1)
                            end, 0.5)
                        end
                    end
                end
            end, 3.0)

            Wait.time(function ()
                for _,obj in ipairs(defuse_zone.getObjects()) do
                    if obj.name == 'Deck' or obj.name == 'Card' then
                        obj.setRotationSmooth({0.0, 0.0, 180.0})
                        obj.setPositionSmooth({0.0, 5.0, 0})
                    end
                end
                for _,obj in ipairs(deck_zone.getObjects()) do
                    if obj.name == 'Deck' then
                        obj.setRotationSmooth({0.0, 0.0, 180.0})
                        obj.setPositionSmooth({0.0, 5.0, 0})
                    end
                end
            end, 4.0)

            Wait.time(function ()
                for _,obj in ipairs(deck_zone.getObjects()) do
                    if obj.name == 'Deck' then
                        for i = 1, cntShuffle do
                            Wait.time(function ()
                                obj.shuffle()
                            end, i * 0.5)
                        end

                        Wait.time(function ()
                            obj.dealToAll(5)
                        end, 0.5 + cntShuffle * 0.5)
                    end
                end
            end, 6.0)

            Wait.time(function ()
                for _,obj in ipairs(exploding_zone.getObjects()) do
                    if obj.name == 'Deck' or obj.name == 'Card' then
                        obj.setRotationSmooth({0.0, 0.0, 180.0})
                        obj.setPositionSmooth({0.0, 5.0, 0})
                    end
                end
            end, 7.0 + cntShuffle * 0.5)

            Wait.time(function ()
            
                for _, playerColor in ipairs(getSeatedPlayers()) do
                    local handObjects = Player[playerColor].getHandObjects()
                    if tablelength(handObjects) > 0 then
                        local card = {}
                        for i, j in pairs(handObjects) do
                            card[i] = j.getPosition()
                        end

                        local shuffledObj = shuffle(handObjects)
                        local shuffledCard = shuffle(card)
                        for i, j in pairs(shuffledObj) do
                            j.setPosition(shuffledCard[i])
                        end
                    end
                end
            end, 8.0 + cntShuffle * 0.5)

            Wait.time(function ()
                for _,obj in ipairs(deck_zone.getObjects()) do
                    if obj.name == 'Deck' then
                        for i = 1, cntShuffle2 do
                            Wait.time(function ()
                                obj.shuffle()
                            end, i * 0.5)
                        end
                    end
                end
            end, 9.0 + cntShuffle * 0.5)
        end
    else
        if (os.time() - drawCardTimer) > 0 then
            drawCardTimer = os.time() + 0.25
            local objects = deck_zone.getObjects()
            if tablelength(objects) >= 1 then
                for _,obj in ipairs(objects) do
                    if obj.name == 'Deck' or obj.name == 'Card' then
                        obj.deal(1, playerColorClicked)
                        break
                    end
                end
                --Wait.time(function ()
                --    local handObjects = Player[playerColorClicked].getHandObjects()
                --    local playerRot = Player[playerColorClicked].getHandTransform().rotation
                --    if tablelength(handObjects) > 0 then
                --        for i, j in pairs(handObjects) do
                --            j.setRotation({0.0, playerRot.y + 180.0, 0.0})
                --        end
                --    end
                --end, 1.0)
            else
                print('Error: 1')
            end
        end
    end
end

function doShuffle(objectButtonClicked, playerColorClicked)
    if os.time() - shuffleHandTimer > 0.0 then
        shuffleHandTimer = os.time() + 0.01

        local playerPos = Player[playerColorClicked].getHandTransform().position
        local playerRot = Player[playerColorClicked].getHandTransform().rotation

        local handObjects = Player[playerColorClicked].getHandObjects()
        local card = {}
        for i, j in pairs(handObjects) do
            card[i] = j.getPosition()
        end

        local shuffledObj = shuffle(handObjects)
        local shuffledCard = shuffle(card)
        for i, j in pairs(shuffledObj) do
            j.setPosition(shuffledCard[i])
            j.setRotation({playerRot.x, playerRot.y + 180, playerRot.z})
        end
    end
end

function shuffle(j)
    for i = #j, 2, -1 do
        local n = math.random(i)
        j[i], j[n] = j[n], j[i]
    end
    return j
end


function insertExploding(objectButtonClicked, playerColorClicked)
    if os.time() - insertExplodingTimer > 0.0 then
        insertExplodingTimer = os.time() + 0.5
        local objects = deck_zone.getObjects()
        local cardsCnt = 0
        for _,obj in ipairs(objects) do
            if obj.name == 'Deck' then
                cardsCnt = tablelength(obj.getObjects())
            elseif obj.name == 'Card' and obj.getDescription() ~= 'exploding' then
                cardsCnt = 1
            end
        end
        if cardsCnt >= 1 then
            local handObjects = Player[playerColorClicked].getHandObjects()
            for _,obj in ipairs(handObjects) do
                if obj.name == 'Card' and obj.getDescription() == 'exploding' then
                    if obj.getInputs() then obj.removeInput(0) end
                    obj.createInput({
                        input_function = "input_func",
                        function_owner = self,
                        label          = "1-"..(cardsCnt + 1),
                        position       = {0, 0.5, -0.25},
                        width          = 1000,
                        height         = 420,
                        color          = {1, 1, 1},
                        font_color     = {0, 0, 0},
                        font_size      = 400,
                        validation     = 2,
                        alignment      = 3,
                    })
                    local button = {}
                    button.click_function = 'submitInsertExploding'
                    button.label = 'Submit'
                    button.position = {0.0, 0.5, 0.5}
                    button.rotation = {0, 0, 0}
                    button.width = 750
                    button.height = 300
                    button.font_size = 200
                    obj.createButton(button)

                    if playerColorClicked == 'Green' then
                        obj.setHiddenFrom({'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Teal' then
                        obj.setHiddenFrom({'Green', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Blue' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Purple' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Pink' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'White' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Brown' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Red' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Orange' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Yellow'})
                    elseif playerColorClicked == 'Yellow' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange'})
                    end

                    return
                end
            end

            for _,obj in ipairs(objects) do
                if obj.name == 'Card' and obj.getDescription() == 'exploding' then
                    if obj.getInputs() then obj.removeInput(0) end
                    obj.createInput({
                        input_function = "input_func",
                        function_owner = self,
                        label          = "1-"..(cardsCnt + 1),
                        position       = {0, 0.5, -0.25},
                        width          = 1000,
                        height         = 420,
                        color          = {1, 1, 1},
                        font_color     = {0, 0, 0},
                        font_size      = 400,
                        validation     = 2,
                        alignment      = 3,
                    })
                    local button = {}
                    button.click_function = 'submitInsertExploding'
                    button.label = 'Submit'
                    button.position = {0.0, 0.5, 0.5}
                    button.rotation = {0, 0, 0}
                    button.width = 750
                    button.height = 300
                    button.font_size = 200
                    obj.createButton(button)

                    if playerColorClicked == 'Green' then
                        obj.setHiddenFrom({'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Teal' then
                        obj.setHiddenFrom({'Green', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Blue' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Purple' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Pink' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'White' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'Brown', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Brown' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Red', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Red' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Orange', 'Yellow'})
                    elseif playerColorClicked == 'Orange' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Yellow'})
                    elseif playerColorClicked == 'Yellow' then
                        obj.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange'})
                    end
                    return
                end
            end
        end
    end
end

function input_func(obj, color, input, stillEditing)
    inputs[obj.guid] = input
    --print('obj.guid: ' .. obj.guid .. ' | ' .. input)
    --print(input)
    --if not stillEditing then
    --    print("Finished editing.")
    --end
end

function switchSpectator(objectButtonClicked, playerColorClicked)
    Player[playerColorClicked].changeColor("Black")
end

function submitInsertExploding(objectButtonClicked, playerColorClicked)

    local input = objectButtonClicked.getInputs()
    if input and inputs[objectButtonClicked.guid] ~= nil then
        local value = tonumber(inputs[objectButtonClicked.guid])


        local objects = deck_zone.getObjects()
        local cardsCnt = 0
        local deck = nil
        for _,obj in ipairs(objects) do
            if obj.name == 'Deck' then
                cardsCnt = tablelength(obj.getObjects())
                deck = obj
            elseif obj.name == 'Card' and obj.getDescription() ~= 'exploding' then
                cardsCnt = 1
                deck = obj
            end
        end
        if deck ~= nil and cardsCnt >= 1 and value >= 1 and value <= cardsCnt + 1 then

            drawStartTimer = os.time() + 5.0
            seeTheFutureTimer = os.time() + 5.0
            insertExplodingTimer = os.time() + 5.0
            shuffleHandTimer = os.time() + 5.0

            if objectButtonClicked.getInputs() then objectButtonClicked.removeInput(0) end
            if objectButtonClicked.getButtons() then objectButtonClicked.removeButton(0) end
            inputs[objectButtonClicked.guid] = nil

            local deck1 = nil
            local deck2 = nil
            local timer1 = 1.0
            local timer2 = 1.5
            local timer3 = 2.0


            objectButtonClicked.setLock(true)
            objectButtonClicked.setRotation({0.0, 0.0, 180.0})
            objectButtonClicked.setPositionSmooth({0.0, 1.6, 0})

            deck1 = deck
                
            if cardsCnt == 1 then
                deck2 = deck1
                if value ~= 1 then
                    timer1 = 2.0
                    timer2 = 1.5
                    timer3 = 1.0
                end
            end
            

            if cardsCnt >= 2 then
                if value == 1 then
                    deck.takeObject({
                        callback_function = function(spawnedObject)
                            spawnedObject.setLock(true)
                            spawnedObject.setRotation({0.0, 0.0, 180.0})
                            spawnedObject.setPositionSmooth({0.0, 1.6, 0})

                            deck2 = spawnedObject
                        end,
                        smooth = false,
                        index = 0,
                    })

                    timer1 = 1.0
                    timer2 = 1.5
                    timer3 = 2.0
                elseif value == 2 then
                    deck.takeObject({
                        callback_function = function(spawnedObject)
                            spawnedObject.setLock(true)
                            spawnedObject.setRotation({0.0, 0.0, 180.0})
                            spawnedObject.setPositionSmooth({0.0, 1.6, 0})

                            deck2 = spawnedObject
                        end,
                        smooth = false,
                        index = 0,
                    })

                    timer1 = 1.0
                    timer2 = 2.0
                    timer3 = 1.5
                elseif value == cardsCnt then
                    deck.takeObject({
                        callback_function = function(spawnedObject)
                            spawnedObject.setLock(true)
                            spawnedObject.setRotation({0.0, 0.0, 180.0})
                            spawnedObject.setPositionSmooth({0.0, 1.6, 0})
                            
                            deck2 = spawnedObject
                        end,
                        smooth = false,
                        index = cardsCnt - 1,
                    })

                    timer1 = 2.0
                    timer2 = 1.0
                    timer3 = 1.5
                elseif value == cardsCnt + 1 then
                    deck.takeObject({
                        callback_function = function(spawnedObject)
                            spawnedObject.setLock(true)
                            spawnedObject.setRotation({0.0, 0.0, 180.0})
                            spawnedObject.setPositionSmooth({0.0, 1.6, 0})

                            deck2 = spawnedObject
                        end,
                        smooth = false,
                        index = 0,
                    })

                    timer1 = 2.0
                    timer2 = 1.5
                    timer3 = 1.0
                elseif value >= 3 and value <= cardsCnt - 1 then
                    local decks = deck.cut(cardsCnt - (value - 1))
                    deck1 = decks[1]
                    deck2 = decks[2]

                    deck2.setLock(true)
                    deck2.setRotation({0.0, 0.0, 180.0})
                    deck2.setPosition({2.5, 1.6, 0})
                    deck2.setPositionSmooth({0.0, 1.6, 0})

                    if tablelength(decks[1].getObjects()) == value - 1 then
                        timer1 = 2.0
                        timer2 = 1.0
                        timer3 = 1.5
                    else
                        timer1 = 1.0
                        timer2 = 2.0
                        timer3 = 1.5
                    end
                end
            end
            Wait.time(function ()
                if cardsCnt == 2 then
                    for _,obj in ipairs(deck_zone.getObjects()) do
                        if obj.name == 'Card' and obj.guid ~= objectButtonClicked.guid and obj.guid ~= deck2.guid and not obj.getInputs() then
                            deck1 = obj
                        end
                    end
                end

                deck1.setLock(true)
                deck1.setRotation({0.0, 0.0, 180.0})
                deck1.setPositionSmooth({0.0, 1.6, 0})
            end, 0.5)

            Wait.time(function ()
                deck1.setRotationSmooth({0.0, 0.0, 180.0})
                deck1.setPositionSmooth({0, 5.0, 0})
                deck1.setLock(false)
            end, timer1)

            Wait.time(function ()
                deck2.setRotationSmooth({0.0, 0.0, 180.0})
                deck2.setPositionSmooth({0, 5.0, 0})
                deck2.setLock(false)
            end, timer2)

            Wait.time(function ()
                objectButtonClicked.setRotationSmooth({0.0, 0.0, 180.0})
                objectButtonClicked.setPositionSmooth({0, 5.0, 0})
                objectButtonClicked.setLock(false)
            end, timer3)
        end
    end


end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function seeFuture(objectButtonClicked, playerColorClicked)
    if (os.time() - seeTheFutureTimer2) > 0 then
        seeTheFutureTimer2 = os.time() + 1.0
        if (os.time() - seeTheFutureTimer) > 0 then
            if seeTheFuturePlayerColour == nil then
                seeTheFutureTimer = os.time() + 10.0

                drawStartTimer = os.time() + 10.0
                insertExplodingTimer = os.time() + 10.0
                shuffleHandTimer = os.time() + 10.0

                seeTheFuturePlayerColour = playerColorClicked
                for _,obj in ipairs(deck_zone.getObjects()) do
                    if obj.name == 'Deck' or obj.name == 'Card' then
                        revealingTopThree = true
                        local playerPos = Player[playerColorClicked].getHandTransform().position
                        local playerRot = Player[playerColorClicked].getHandTransform().rotation
                        if obj.name == 'Card' then
                            local newX = playerPos.x - 30.0 * math.cos((playerRot.y + 90) / 180.0 * 3.14)
                            local newY = playerPos.z + 30.0 * math.sin((playerRot.y + 90) / 180.0 * 3.14)
                            obj.setPositionSmooth({newX, 10.0, newY})
                            obj.setRotationSmooth({0.0, playerRot.y + 180.0, 180.0})
                            Wait.time(function ()
                                take_callback(1, obj, newX, newY, playerRot.y + 180.0)
                            end, 0.5)
                        else
                            local countCards = math.min(obj.getQuantity(), 3)
                            if countCards ~= -1 then
                                for i=1,countCards do
                                    local i2 = i
                                    if countCards == 2 and i == 2 then i2 = 3 end
                                    if deckExists(deck_zone) then
                                        local newX = playerPos.x - 30.0 * math.cos((20 * i2 - 40 + playerRot.y + 90) / 180.0 * 3.14)
                                        local newY = playerPos.z + 30.0 * math.sin((20 * i2 - 40 + playerRot.y + 90) / 180.0 * 3.14)
                                        takeParams =
                                        {
                                            position = {newX, 10.0, newY},
                                            rotation = {0.0, playerRot.y + 180.0, 180.0},
                                            callback_function = function(obj) take_callback(i, obj, newX, newY, playerRot.y + 180.0) end
                                        }
                                        obj.takeObject(takeParams)
                                    end 
                                end
                            else
                                print('Error: 2')
                                seeTheFuturePlayerColour = nil
                            end
                        end

                        Wait.time(function ()
                            revealingTopThree = false
                        end, 5.0)
                        Wait.time(function ()
                            if topThreeCardsGUID[3] ~= nil then
                                local cardObject = getObjectFromGUID(topThreeCardsGUID[3])
                                if cardObject ~= nil then
                                    cardObject.setLock(false)
                                    cardObject.setRotationSmooth({0.0, 0.0, 180.0})
                                    sendCardBackToDrawDeck(cardObject)
                                end
                            end
                        end, 5.25)
                        Wait.time(function ()
                            if topThreeCardsGUID[2] ~= nil then
                                local cardObject = getObjectFromGUID(topThreeCardsGUID[2])
                                if cardObject ~= nil then
                                    cardObject.setLock(false)
                                    cardObject.setRotationSmooth({0.0, 0.0, 180.0})
                                    sendCardBackToDrawDeck(cardObject)
                                end
                            end
                        end, 5.5)
                        Wait.time(function ()
                            if topThreeCardsGUID[1] ~= nil then
                                local cardObject = getObjectFromGUID(topThreeCardsGUID[1])
                                if cardObject ~= nil then
                                    cardObject.setLock(false)
                                    cardObject.setRotationSmooth({0.0, 0.0, 180.0})
                                    sendCardBackToDrawDeck(cardObject)
                                end
                            end
                        end, 5.75)
                        Wait.time(function ()
                            topThreeCardsGUID = {nil, nil, nil}
                            seeTheFuturePlayerColour = nil
                        end, 6.0)
                        break
                    end
                end
            else
                print('Error: 4')
                seeTheFuturePlayerColour = nil
            end
        end
    end
end
function deckExists(selectedDeckZone)
    return getDeck(selectedDeckZone) != nil
end

function getDeck(selectedDeckZone)
    local deckZoneObjects = selectedDeckZone.getObjects()
    for _, item in ipairs(deckZoneObjects) do
        if item.tag =='Deck' then
            return item
        end
    end
    for _, item in ipairs(deckZoneObjects) do
        if item.tag =='Card' then
            return item
        end
    end
    return nil
end

function take_callback(i, object_spawned, newX, newY, RotY)
    if seeTheFuturePlayerColour ~= nil then
        object_spawned.setLock(true)
        topThreeCardsGUID[i] = object_spawned.guid

        if seeTheFuturePlayerColour == 'Green' then
            object_spawned.setHiddenFrom({'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Teal' then
            object_spawned.setHiddenFrom({'Green', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Blue' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Purple' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Pink', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Pink' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'White', 'Brown', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'White' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'Brown', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Brown' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Red', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Red' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Orange', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Orange' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Yellow'})
        elseif seeTheFuturePlayerColour == 'Yellow' then
            object_spawned.setHiddenFrom({'Green', 'Teal', 'Blue', 'Purple', 'Pink', 'White', 'Brown', 'Red', 'Orange'})
        end

        local button = {}
        button.click_function = 'nulFunc'
        button.label = i
        button.position = {0, 2.0, 2.0}
        button.rotation = {0, 0, 0}
        button.scale = {0.5, 0.5, 0.5}
        button.font_size = 400
        button.width = 0
        button.height = 0
        button.color = {1, 1, 1, 1}
        button.font_color = {1, 1, 1, 1}
        object_spawned.createButton(button)

        button.position = {0,2.0,-2.0}
        object_spawned.createButton(button)

        Wait.time(function ()
            object_spawned.setPositionSmooth({newX, 10.0, newY})
            object_spawned.setRotationSmooth({0.0, RotY, 0.0})
        end, 0.1)
    end
end
function sendCardBackToDrawDeck(_cardObject)
    local cardObject=_cardObject
    cardObject.setPositionSmooth({0, 5.0, 0})
    Wait.time(function ()
        cardObject.setHiddenFrom({})
    end, 0.5)
end
