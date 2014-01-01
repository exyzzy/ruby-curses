
require "./bits"
require "./charpix"
include Math


@xSize = 220
@ySize = 120
    
def bounce (t)
  x0 =rand(@xSize)
  x1 = rand(@xSize)
  y0 = rand(@ySize)
  y1 = rand(@ySize)
  dx0 = rand(5) - 2
  dx1 = rand(5) - 2
  dy0 = rand(5) - 2
  dy1 = rand(5) - 2
  Curses.timeout = 0  # non-blocking key input so the animation continues

  while TRUE
    t.clear
    # border
    0.upto(@xSize-1) do |s|
      t.set(s, 0)
      t.set(s, @ySize-1)
    end

    0.upto(@ySize-1) do |s|
      t.set(0, s)
      t.set(@xSize-1, s)
    end

    t.line(x0, y0, x1, y1)

    if (x0 >= @xSize - 2) || (x0 <= 0)
      dx0 = -dx0
    end
    if (x1 >= @xSize - 2) || (x1 <= 0)
      dx1 = -dx1
    end
    if (y0 >= @ySize - 2) || (y0 <= 0)
      dy0 = -dy0
    end
    if (y1 >= @ySize - 2) || (y1 <= 0)
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

# class Graph
#   def initialize()
# end


def graph(t)
  xZero = @xSize / 2
  yZero = @ySize / 2
  x0Scale =  -PI
  xNScale = PI
  y0Scale = 1.0
  yNScale = -1.0
  delta = 0.05


  Curses.timeout = 0  # non-blocking key input so the animation continues
  Curses.stdscr.keypad(true) # enable arrow keys (required for pageup/down)
  while TRUE
    t.clear

    #Draw Zero Axes
    t.line(xZero, 0, xZero, @ySize-1)
    t.line(0, yZero, @xSize-1, yZero)

    0.upto(@xSize-1) do |x|
      xr = ((x.to_f / @xSize.to_f) * (xNScale - x0Scale)) + x0Scale
      yr = Math.sin(xr)
      y = (((yr - y0Scale) / (yNScale - y0Scale)) * @ySize).to_i
      #puts "#{x}, #{y} =  #{xr}, #{yr}"
      t.set(x, y)
    end

    # Draw Curve


    t.render
    yRange = yNScale - y0Scale
    xRange = xNScale - x0Scale
    case Curses.getch
      when Curses::Key::UP
        y0Scale += yRange * delta
        yNScale += yRange * delta
      when Curses::Key::DOWN
        y0Scale -= yRange * delta
        yNScale -= yRange * delta
      when Curses::Key::RIGHT
        x0Scale += xRange * delta
        xNScale += xRange * delta
      when Curses::Key::LEFT
        x0Scale -= xRange * delta
        xNScale -= xRange * delta
      # when 10 then do_something # enter
      when ?+
        x0Scale += xRange * delta
        xNScale -= xRange * delta
        y0Scale += yRange * delta
        yNScale -= yRange * delta
      when ?-
        x0Scale -= xRange * delta
        xNScale += xRange * delta
        y0Scale -= yRange * delta
        yNScale += yRange * delta
      when ?q then return # quit
    end
  end
end

t = CharPix.new(@xSize, @ySize)
graph(t)
#bounce(t)

