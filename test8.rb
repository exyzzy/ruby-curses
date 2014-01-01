
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
#    if (@screenCols > cols) || (@screenLines > lines)
#       close_screen
#       abort("Term size is #{cols} x #{lines}: Resize term window to at least #{@screenCols} x #{@screenLines}")
#     end
#     resizeterm(@screenLines, @screenCols) #still have to manually resize
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
    clear
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
    refresh
  end # render

  def bounce
    x = 1
    y = 1
    dx = 1
    dy = 1
    sz = 5
    while TRUE
      clearBits
      0.upto(sz) do |s|
        @bits[0+x][s+y] = 1
        @bits[s+x][0+y] = 1
        @bits[sz+x][s+y] = 1
        @bits[s+x][sz+y] = 1
      end
      if (x + sz) >= @xSize-2
        dx = -dx
      end
      if (y + sz) >= @ySize-2
        dy = -dy
      end
      if x <= 0
        dx = -dx
      end
      if y <= 0
        dy = -dy
      end
      x = x + dx
      y = y + dy

      #clear
      render
      #refresh
    end
  end

end # CurseGX

t = CurseGX.new(100, 100)
t.bounce

