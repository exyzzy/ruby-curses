
# encoding: UTF-8

require "curses"
include Curses

class CurseGX

  def initialize
    curs_set(0) # turn off cursor
    init_screen
    nl
    noecho
    @utf8Block = [ " ",            # 0000
                "\xe2\x96\x97", # 0001
                "\xe2\x96\x96", # 0010
                "\xe2\x96\x84", # 0011
                "\xe2\x96\x9d", # 0100
                "\xe2\x96\x90", # 0101
                "\xe2\x96\x9e", # 0110
                "\xe2\x96\x9f", # 0111
                "\xe2\x96\x98", # 1000
                "\xe2\x96\x9a", # 1001
                "\xe2\x96\x8c", # 1010
                "\xe2\x96\x99", # 1011
                "\xe2\x96\x80", # 1100
                "\xe2\x96\x9c", # 1101
                "\xe2\x96\x9b", # 1110
                "\xe2\x96\x88"] # 1111

    @myBlock = [ " ",            # 0000
                "\xe2\x96\x84", # 0011
                "\xe2\x96\x80", # 1100
                "\xe2\x96\x88"] # 1111

  end

  def test
    x = 0
    y = 0
    deltax = 1
    deltay = 1

    while TRUE
    	setpos(y, x)
    	addstr("\xe2\x96\x88")	
    	x = x + deltax
    	y = y + deltay
    	if y >= lines || y <= 0 
    		deltay = -deltay
    	end
    	if x >= cols || x <= 0
    		deltax = -deltax
    	end
    	refresh
    	sleep(0.025)
    	clear
    end
  end # test

  def test2
    while TRUE
      0.upto(15) do |y|
        0.upto(15) do |x|
          setpos(y, x)
          addstr(@utf8Block[x])
        end
      end
      0.upto(15) do |i|
        setpos(0, i)
        addstr("0")
      end
      0.upto(3) do |i|
        setpos(1,i)
        # addstr(@myBlock[i])
        addstr("\xe2\xa3\xbf")
      end
      0.upto(3) do |i|
        setpos(2,i)
        # addstr(@myBlock[i])
        addstr("\xe2\xa3\xbf")
      end
      0xa0.upto(0xa3) do |i|
        0x80.upto(0xbf) do |j|

          setpos(i-0xa0,j-0x80)
          # addstr(@myBlock[i])
          astr = "\xe2"
          astr << i
          astr << j
          addstr(astr)
        end
      end
      refresh
      sleep(0.01)
      clear
    end
  end

end # CurseGX

t = CurseGX.new
t.test2

# r = lines - 4
# c = cols - 4
# for i in 0 .. 4
#   xpos[i] = (c * ranf).to_i + 2
#   ypos[i] = (r * ranf).to_i + 2
# end

# i = 0
# while TRUE
#   x = (c * ranf).to_i + 2
#   y = (r * ranf).to_i + 2

#   setpos(y, x); addstr(".")

#   setpos(ypos[i], xpos[i]); addstr("o")

#   i = if i == 0 then 4 else i - 1 end
#   setpos(ypos[i], xpos[i]); addstr("O")

#   i = if i == 0 then 4 else i - 1 end
#   setpos(ypos[i] - 1, xpos[i]);      addstr("-")
#   setpos(ypos[i],     xpos[i] - 1); addstr("|.|")
#   setpos(ypos[i] + 1, xpos[i]);      addstr("-")

#   i = if i == 0 then 4 else i - 1 end
#   setpos(ypos[i] - 2, xpos[i]);       addstr("-")
#   setpos(ypos[i] - 1, xpos[i] - 1);  addstr("/ \\")
#   setpos(ypos[i],     xpos[i] - 2); addstr("| O |")
#   setpos(ypos[i] + 1, xpos[i] - 1); addstr("\\ /")
#   setpos(ypos[i] + 2, xpos[i]);       addstr("-")

#   i = if i == 0 then 4 else i - 1 end
#   setpos(ypos[i] - 2, xpos[i]);       addstr(" ")
#   setpos(ypos[i] - 1, xpos[i] - 1);  addstr("   ")
#   setpos(ypos[i],     xpos[i] - 2); addstr("     ")
#   setpos(ypos[i] + 1, xpos[i] - 1);  addstr("   ")
#   setpos(ypos[i] + 2, xpos[i]);       addstr(" ")

#   xpos[i] = x
#   ypos[i] = y
#   refresh
#   sleep(0.5)
# end

# end of main
