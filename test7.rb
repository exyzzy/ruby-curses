
# encoding: UTF-8

require "./bits"
require "curses"
include Curses

class CurseGX

  def initialize(xSize, ySize)
    @xSize = xSize
    @ySize = ySize
    @screenCols = (xSize/2).to_i
    @screenLines = (ySize/4).to_i
    curs_set(0) # turn off cursor
    init_screen
    nl
    noecho
 #   if (@screenCols > cols) || (@screenLines > lines)
#       close_screen
#       abort("Term size is #{cols} x #{lines}: Resize term window to at least #{@screenCols} x #{@screenLines}")
#     end
# #    resizeterm(@screenLines, @screenCols) #still have to manually resize
    @bits = Array.new(@ySize) {Bits.new(@xSize)}
    # puts("size #{@bits.size} #{@bits[0].size}")
    @mapping = [[1,3], [0,3], [1,2], [1,1], [1,0], [0,2], [0,1], [0,0]]
  end

  def clearBits
    @bits.each do |b|
      b.zero
    end
  end

  def render
    # braille encoding from UL: (1,3) (0,3) (1,2) (1,1) (1,0) (0,2) (0,1) (0,0)
    0.upto(@screenLines-1) do |y|
      0.upto(@screenCols-1) do |x|
        startX = x * 2
        startY = y * 4
        nn = 0
        0.upto(7) do |i|
          nn = nn << 1
          nn = nn | @bits[startX + @mapping[i][0]][startY + @mapping[i][1]]
        end
        aa = 0xa0 + (nn / 64)
        bb = 0x80 + (nn % 64)
        astr = "\xe2"
        astr << aa
        astr << bb
        setpos(y, x)
        addstr(astr)
      end
    end
  end # render

  def test3
#    @bits[0].print
#    @bits[1].print
    while TRUE
      0.upto(40) do |j|
        clearBits
        0.upto(50) do |i|
            @bits[i+j][i] = 1
        end

        render
        refresh
      end
    end
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

t = CurseGX.new(100, 100)
t.test3

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
