
# encoding: UTF-8

# charpix.rb: Ruby class for displaying primitive graphics on UTF-8 compatible terminals
# using Curses and the Braille character set for dots.
# Author: Eric Lang
# For more info: www.exyzzy.com

require "./bits"
require "curses"
include Curses

class CharPix
  attr_reader :xSize, :ySize

  def initialize(xSize, ySize)
    @xSize = xSize
    @ySize = ySize
    @screenCols = (xSize/2).to_i  + ((ySize % 2 == 0) ? 0 : 1 ) # min((xSize % 2), 1)
    @screenLines = (ySize/4).to_i + ((xSize % 4 == 0) ? 0 : 1 ) # min((xSize % 4), 1)

    curs_set(0) # turn off cursor
    init_screen
    nl
    noecho
    if (@screenCols > cols) || (@screenLines > lines)
      close_screen
      abort("Term size is #{cols} x #{lines}: Resize term window to at least #{@screenCols} x #{@screenLines}")
    end
    resizeterm(@screenLines, @screenCols) #still have to manually resize
    @bits = Array.new(@xSize) {Bits.new(@ySize)}
    @mapping = [[1,3], [0,3], [1,2], [1,1], [1,0], [0,2], [0,1], [0,0]]
  end

  def clear
    @bits.each do |b|
      b.zero
    end
  end

  def cols
    @screenCols
  end

  def lines
    @screenLines
  end

  # render the bitmap to the screen using Braille dots, single buffered of course
  def render
    Curses.clear
    # braille encoding from UL: (1,3) (0,3) (1,2) (1,1) (1,0) (0,2) (0,1) (0,0)
    setpos(0,0)
    0.upto(@screenLines-1) do |y|
      0.upto(@screenCols-1) do |x|
        startX = x << 1  # x * 2
        startY = y << 2  # y * 4
        # nn = 0
        # 0.upto(7) do |i|
        #   nn = nn << 1
        #   nn = nn | @bits[startX + @mapping[i][0]][startY + @mapping[i][1]]
        # end
        # aa = 0xa0 + (nn >> 6)
        # bb = 0x80 + (nn % 64)
        # ...rewritten below to get rid of final / and & operations
        aa = 0
        bb = 0
        0.upto(1) do |i|
          aa = aa << 1
          aa = aa | @bits[startX + @mapping[i][0]][startY + @mapping[i][1]]
        end
        2.upto(7) do |i|
          bb = bb << 1
          bb = bb | @bits[startX + @mapping[i][0]][startY + @mapping[i][1]]
        end
        aa += 0xa0
        bb += 0x80


        astr = "\xe2"
        astr << aa
        astr << bb
        #setpos(y, x) # don't need to do this every character since we print them all in order
        addstr(astr)
      end
    end
    refresh
  end # render

  def set (x, y)
    @bits[x][y] = 1
  end

  def unset (x, y)
    @bits[x][y] = 0
  end

  # Bresenham's Line
  def line (x0, y0, x1, y1)
    dx = (x1 - x0).abs
    dy = (y1 - y0).abs
    sx = (x0 < x1) ? 1 : -1
    sy = (y0 < y1) ? 1 : -1
    err = dx - dy

    while TRUE
      @bits[x0][y0] = 1
      if (x0 == x1) && (y0 == y1) then
        return TRUE
      end
      e2 = 2 * err
      if e2 > -dy then
        err = err - dy
        x0 = x0 + sx
      end
      if e2 < dx then
        err = err + dx
        y0 = y0 + sy
      end
    end
  end

end # CharPix

# Line that animates all over the screen area
def test(t)
  x0 =rand(t.xSize)
  x1 = rand(t.xSize)
  y0 = rand(t.ySize)
  y1 = rand(t.ySize)
  dx0 = rand(5) - 2
  dx1 = rand(5) - 2
  dy0 = rand(5) - 2
  dy1 = rand(5) - 2
  Curses.timeout = 0  # non-blocking key input so the animation continues

  while TRUE
    t.clear
    # border
    0.upto(t.xSize-1) do |s|
      t.set(s, 0)
      t.set(s, t.ySize-1)
    end

    0.upto(t.ySize-1) do |s|
      t.set(0, s)
      t.set(t.xSize-1, s)
    end

    t.line(x0, y0, x1, y1)

    if (x0 >= t.xSize - 2) || (x0 <= 0)
      dx0 = -dx0
    end
    if (x1 >= t.xSize - 2) || (x1 <= 0)
      dx1 = -dx1
    end
    if (y0 >= t.ySize - 2) || (y0 <= 0)
      dy0 = -dy0
    end
    if (y1 >= t.ySize - 2) || (y1 <= 0)
      dy1 = -dy1
    end

    x0 += dx0
    x1 += dx1
    y0 += dy0
    y1 += dy1

    t.render

    case Curses.getch
      when ?q then return # quit
    end
  end
end

t = CharPix.new(ARGV[0].to_i, ARGV[1].to_i)
#test(t)  # uncomment to test: ruby charpix.rb 220 120

