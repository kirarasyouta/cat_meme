require 'dxruby'

Window.width = 1920
Window.height = 1200
Window.windowed = false

player = Sprite.new(100, 1000, Image.load("images/cat1-3.png"))
player2 = Sprite.new(100, 1000, Image.load("images/cat3-2.png"))
image_count = 0
image_count_reset = false

ground = [
    Sprite.new(0, 1180, Image.new(1920, 20, C_GREEN))
]

walls = []

walls_spead = 20
wall_height = 280
wall_height_x = 900
wall_count = 342
wall_spawn = true
wall_height_rand = 1

jump = 0
jump_count = 0
jump_image = true

game_start = true
game_los = false

bgm = Sound.new("bgm/bgm2.wav")
bgm.loop_count = -1

point = 0

Window.loop do
    if game_start
        Window.draw_font(100, 100, "ぴーですたと", Font.default)
        if Input.key_push?(K_P)
            game_start = false
            bgm.play
        end
    elsif game_los
        Window.draw_font(100, 100, "おめでとう！\n今回の得点は#{point}点！\nぴーでしょきがめん", Font.default)
        if Input.key_push?(K_P)
            game_start = true
            game_los = false
            player.x = 100
            player.y = 1000
            walls_spead = 20
            wall_height = 280
            wall_height_x = 900
            wall_count = 342
            wall_height_rand = 1
            point = 0
            Sprite.clean(walls)
        end
    else
        Sprite.draw(ground)

        player.y += 10
        
        Window.draw_font(100, 100, "ジャンプカウント#{jump}\nジャンプ制限#{jump_count}\n壁の配列#{walls.size}\nジャンプイメージ#{jump_image}\nイメージカウント#{image_count}", Font.default)
        Window.draw_font(400, 100, "得点#{point}", Font.default)
        image_count += 1
        player.draw
        if jump_image
            if  image_count == 5
                player,player2 = player2,player
                image_count = 0
            end
        end

        #プレイヤー
        if jump_count < 1
            if Input.key_push?(K_SPACE)
                jump = 10
                jump_count += 1
                jump_image = false
                image_count_reset = true
            end
        end
        if jump > 0
            player.y -= 60
            jump -= 1
        end
        player.check(ground).each do
            player.y -= 10
            jump_count = 0
            jump_image = true
            if image_count_reset
                image_count = 0
                image_count_reset = false
            end
        end
        if wall_spawn
            wall = Sprite.new(1920, wall_height_x, Image.new(150, wall_height, C_BLUE))
            walls.push(wall)
            wall_spawn = false
        end
        Sprite.draw(walls)
        if !walls.empty?
            walls.each do |obj|
                if obj.x > -150
                    obj.x -= walls_spead
                end
                if player.x == obj.x
                    point += 10
                end
                if obj.x <= -150
                    obj.vanish
                    wall_spawn = true
                    walls_spead = 20
                    wall_height_rand = 1
                end
            end
            Sprite.clean(walls)
        end
        if wall_height_rand == 1
            wall_height = 280
            wall_height_x = 900
        end
        if wall_height_rand == 2
            wall_height = 380
            wall_height_x = 800
        end
        if wall_height_rand == 3
            wall_height = 480
            wall_height_x = 700
        end

        player.check(walls).each do
            player.x -= 200
        end
        if player.x < 100
            game_los = true
            bgm.stop
        end
    end
    break if Input.key_push?(K_ESCAPE)
end