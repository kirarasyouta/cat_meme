require 'dxruby'

a = Sprite.new(100, 100, Image.load("images/cat1-3.png"))
b = Sprite.new(100, 100, Image.load("images/cat3-2.png"))
c = 0
d = 0

Window.loop do
    d += 1
    a.draw
    if d == 5
        a,b = b,a
        d = 0
    end
    # case c
    #     when 0
    #         a.draw
    #     when 1
    #         b.draw
    # end
end