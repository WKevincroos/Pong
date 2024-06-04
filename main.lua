WINDOW_WIDTH, WINDOW_HEIGHT = 800, 600
VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 400, 300

function love.load()

    math.randomseed(os.time())

    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("Pong")

    small_font = love.graphics.newFont("font.ttf", 8)
    score_font = love.graphics.newFont("font.ttf", 32)

    sounds = {
        ['paddle_hit'] = love.audio.newSource("Sounds/paddle_hit.wav", "static"),
        ['score'] = love.audio.newSource("Sounds/score.wav", "static"),
        ['wall_hit'] = love.audio.newSource("Sounds/wall_hit.wav", "static"),
        ['win'] = love.audio.newSource("Sounds/win.wav", "static")
    }

    push = require "Libraries/push"
    Class = require "Libraries/class"

    require "Classes/Ball"
    require "Classes/Paddle"

    ball = Ball(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2)

    player1 = Paddle(30, VIRTUAL_HEIGHT / 2, 25)
    player2 = Paddle(VIRTUAL_WIDTH - 30, VIRTUAL_HEIGHT / 2, 25)

    player1score = 0
    player2score = 0
    playerserve = 1
    winner = nil

    game_state = "start"
    collides = false

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.update(dt)

-- Border collisions

    if ball.y < 0 then
        ball.y = 0
        ball.velY = -ball.velY
        sounds['wall_hit']:play()
    end
    if ball.y > VIRTUAL_HEIGHT then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.velY = -ball.velY
        sounds['wall_hit']:play()
    end

-- Player 1 logic

    if love.keyboard.isDown('w') then
        player1.speed = -200
    elseif love.keyboard.isDown('s') then
        player1.speed = 200
    else
        player1.speed = 0
    end

    if ball:collides(player1) then
        ball.velX = -ball.velX * 1.03

        ball.x = player1.x + 5

        if ball.velY < 0 then
            ball.velY = -math.random(10, 150)
        else
            ball.velY = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    end

    if ball.x < 0 then
        playerserve = 1
        player2score = player2score + 1

        if player2score == 10 then
            winner = 2
            game_state = "done"
            sounds['win']:play()
        else
            game_state = "serve"
        end

        sounds['score']:play()
        ball:reset()
    end

-- Player 2 logic

    if love.keyboard.isDown('up') then
        player2.speed = -200
    elseif love.keyboard.isDown('down') then
        player2.speed = 200
    else
        player2.speed = 0
    end
    if ball:collides(player2) then
        ball.velX = -ball.velX * 1.03
        ball.velY = math.random(-50, 50) * 1.03

        ball.x = player2.x - 4

        if ball.velY < 0 then
            ball.velY = -math.random(10, 150)
        else
            ball.velY = math.random(10, 150)
        end
        sounds['paddle_hit']:play()
    end

    if ball.x > VIRTUAL_WIDTH then
        playerserve = 2
        player1score = player1score + 1

        if player1score == 10 then
            winner = 1
            game_state = "done"
            sounds['win']:play()
        else
            game_state = "serve"
        end

        sounds['score']:play()
        ball:reset()
    end

-- Game logic

    if game_state == "play" then
        ball:update(dt)
    end


    player1:update(dt)
    player2:update(dt)
end

function love.draw()
    push:apply('start')

    love.graphics.clear(0.5, 0.1, 0.2, 1)

    if game_state == "start" then
        love.graphics.setFont(small_font)
        love.graphics.printf("Welcome to Pong!", 0, VIRTUAL_HEIGHT / 2 - 140, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to begin!", 0, VIRTUAL_HEIGHT / 2 - 130, VIRTUAL_WIDTH, "center")
    elseif game_state == "serve" then
        love.graphics.printf("Player " .. playerserve .. " serve's", 0, VIRTUAL_HEIGHT / 2 - 140, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to restart!", 0, VIRTUAL_HEIGHT / 2 - 130, VIRTUAL_WIDTH, "center")
    elseif game_state == "done" then
        love.graphics.setFont(score_font)
        love.graphics.printf("Player " .. winner .. " wins!", 0, VIRTUAL_HEIGHT / 2 - 140, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(small_font)
        love.graphics.printf("Press Enter to restart!", 0, VIRTUAL_HEIGHT / 2 - 100, VIRTUAL_WIDTH, "center")
    end

    love.graphics.setFont(score_font)
    love.graphics.print(tostring(player1score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2score), VIRTUAL_WIDTH / 2 + 40, VIRTUAL_HEIGHT / 3)

    love.graphics.setFont(small_font)
    love.graphics.printf("Otavio Augustus - 2024", 0, VIRTUAL_HEIGHT / 2 + 130, VIRTUAL_WIDTH, "center")

    ball:draw()
    player1:draw()
    player2:draw()

    --debug()

    push:apply('end')
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" and game_state ~= "play" then
        if game_state == "done" then
            player1score = 0
            player2score = 0
            game_state = "serve"
        else
            game_state = "play"     
            ball:reset()
            if playerserve == 1 then
                ball.velX = math.random(140, 200)
            else
                ball.velX = -math.random(140, 200)
            end
        end
    end
end

function love.resize(w, h)
    push:resize(w, h)
end

function debug()
    love.graphics.setFont(small_font)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, VIRTUAL_HEIGHT / 2 - 140)
    love.graphics.print("State: " .. game_state, 10, VIRTUAL_HEIGHT / 2 - 130)
end