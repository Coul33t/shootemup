debug = true

IS_ALIVE = true
SCORE = 0

CAN_SHOOT = true
CAN_SHOOT_TIMERMAX = 0.5
CAN_SHOOT_TIMER = CAN_SHOOT_TIMERMAX

CREATE_ENEMY_TIMERMAX = 2
CREATE_ENEMY_TIMER = CREATE_ENEMY_TIMERMAX

enemy_img = nil
enemies = {}

bullet_img = nil
bullets = {}

player = {
  x = 256,
  y = 710,
  speed = 150,
  img = nil,
}

function love.load(arg)
  player.img = love.graphics.newImage('assets/player.png')
  bullet_img = love.graphics.newImage('assets/bullet.png')
  enemy_img = love.graphics.newImage('assets/enemy.png')
end

function love.update(dt)
  timer(dt)
  createEnnemy(dt)

  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end

  if love.keyboard.isDown('space') and CAN_SHOOT then
    shoot()
  end


  if love.keyboard.isDown('q') then
    if player.x > 0 then
      player.x = player.x - (player.speed * dt)
    end

  elseif love.keyboard.isDown('d') then
    if player.x < love.graphics.getWidth() - player.img:getWidth() then
      player.x = player.x + (player.speed * dt)
    end
  end


  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y - (250 * dt)
    if bullet.y < 0 then
      table.remove(bullet, i)
    end
  end

  for i, enemy in ipairs(enemies) do
    enemy.y = enemy.y + (100 * dt)

    if enemy.y > love.graphics.getHeight() + enemy.img:getHeight()/2 then
      table.remove(enemies, i)
    end
  end

  for i, enemy in ipairs(enemies) do
    for j, bullet in ipairs(bullets) do
      if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
        table.remove(bullets, j)
        table.remove(enemies, i)
        SCORE = SCORE + 1
      end
    end

    if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) and IS_ALIVE then
  		table.remove(enemies, i)
  		IS_ALIVE = false
  	end
  end

  if not IS_ALIVE and love.keyboard.isDown('r') then
    bullets = {}
    enemies = {}

    CAN_SHOOT_TIMER = CAN_SHOOT_TIMERMAX
    CREATE_ENEMY_TIMER = CREATE_ENEMY_TIMERMAX

    player.x = 256
    player.y = 710

    SCORE = 0
    IS_ALIVE = true
  end
end

function love.draw(dt)
  if IS_ALIVE then
    love.graphics.draw(player.img, player.x, player.y)
  else
    love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.draw(bullet.img, bullet.x, bullet.y)
  end

  for i, enemy in ipairs(enemies) do
    love.graphics.draw(enemy.img, enemy.x, enemy.y)
  end
end


function timer(dt)
  CAN_SHOOT_TIMER = CAN_SHOOT_TIMER - (1 * dt)
  if CAN_SHOOT_TIMER < 0 then
    CAN_SHOOT = true
  end
end

function shoot()
  new_bullet = {x = player.x + (player.img:getWidth()/2), y = player.y, img = bullet_img}
  table.insert(bullets, new_bullet)
  CAN_SHOOT = false
  CAN_SHOOT_TIMER = CAN_SHOOT_TIMERMAX
end

function createEnnemy(dt)
  CREATE_ENEMY_TIMER = CREATE_ENEMY_TIMER - (1 * dt)
  if CREATE_ENEMY_TIMER < 0 then
    random_pos = math.random(0, love.graphics.getWidth() - enemy_img:getWidth())
    new_enemy = {x = random_pos, y = -10, img = enemy_img}
    table.insert(enemies, new_enemy)

    CREATE_ENEMY_TIMER = CREATE_ENEMY_TIMERMAX
  end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
