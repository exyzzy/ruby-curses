
# graph.rb: Ruby class for graphing Ruby equations of the form y = fn(x) 
# using the CharPix class and Ruby's eval
# Author: Eric Lang
# For more info: www.exyzzy.com

require "./bits"
require "./charpix"
include Math

class Graph
  def initialize(xSize, ySize)
    @xSize = xSize
    @ySize = ySize
    @pix = CharPix.new(@xSize, @ySize)
    Curses.timeout = 0  # non-blocking key input so the animation continues
    Curses.stdscr.keypad(true) # enable arrow keys (required for pageup/down)   
    @eq = "y = sin(x)"
  end

  # equation string entry
  def getstr
    Curses.timeout = -1   # wait for full string
    echo
    @eq = Curses.getstr
    Curses.timeout = 0
    noecho
  end


  def graph
    # start out with a nice scale for sin(x) 
    x0Scale =  -PI
    xNScale = PI
    y0Scale = 1.0
    yNScale = -1.0
    delta = 0.05

    while TRUE
      y = 0.0
      @pix.clear

      #Draw Zero Axes
      ypa = (((0 - y0Scale) / (yNScale - y0Scale)) * @ySize).to_i
      if (ypa >=0 && ypa <= @ySize) then
        @pix.line(0, ypa, @xSize-1, ypa)
      end

      xpa = (((0 - x0Scale) / (xNScale - x0Scale)) * @xSize).to_i
      if (xpa >=0 && xpa <= @xSize) then
        @pix.line(xpa, 0, xpa, @ySize-1)
      end

      # Draw equation
      1.upto(@xSize-1) do |xp|
        begin
          x = ((xp.to_f / @xSize.to_f) * (xNScale - x0Scale)) + x0Scale
          # for instance "y = sin(x)"
          eval(@eq)
          yp = (((y - y0Scale) / (yNScale - y0Scale)) * @ySize).to_i
          if (xp >= 0 && xp <= @xSize) && (yp >=0 && yp <= @ySize) then
            @pix.set(xp, yp)
          end
        rescue
          #catch eval errors and continue
        end
      end

      @pix.render

      # print equation string
      Curses.setpos(@pix.lines - 1, 0)
      addstr(@eq)

      # Draw scale numbers along X
      Curses.setpos((@ySize / 8), 0)
      addstr("%1.3f" % x0Scale)

      str = "%1.3f" % xNScale
      Curses.setpos((@ySize / 8), @xSize/2 - str.size)
      addstr(str)

      # Draw scale numbers along Y
      str = "%1.3f" % y0Scale
      Curses.setpos(0, (@xSize/4) - 3)
      addstr(str)

      str = "%1.3f" % yNScale
      Curses.setpos(@ySize/4 - 1, (@xSize/4) - 3)
      addstr(str)
      refresh


      # handle key input
      yRange = yNScale - y0Scale
      xRange = xNScale - x0Scale
      case Curses.getch
        when Curses::Key::UP
          y0Scale -= yRange * delta
          yNScale -= yRange * delta
        when Curses::Key::DOWN
          y0Scale += yRange * delta
          yNScale += yRange * delta
        when Curses::Key::RIGHT
          x0Scale += xRange * delta
          xNScale += xRange * delta
        when Curses::Key::LEFT
          x0Scale -= xRange * delta
          xNScale -= xRange * delta
        when ?+, ?=   # zoom in
          x0Scale += xRange * delta
          xNScale -= xRange * delta
          y0Scale += yRange * delta
          yNScale -= yRange * delta
        when ?-, ?_   # zoom out
          x0Scale -= xRange * delta
          xNScale += xRange * delta
          y0Scale -= yRange * delta
          yNScale += yRange * delta
        when ?e, ?E   # equation entry
          # clear old equation string
          Curses.setpos(@pix.lines - 1, 0)
          addstr(' ' * @eq.size)
          # enter new equation
          Curses.setpos(@pix.lines - 1, 0)
          addstr("Equation: ")
          Curses.refresh
          getstr
        when ?q, ?Q then return # quit
      end
    end
  end
end


g = Graph.new(ARGV[0].to_i, ARGV[1].to_i)
g.graph

# call with (example): ruby graph.rb 220 120
# e or E to enter equation of the form y = fn(x), use ruby math syntax ex. y = sin(x)
# + or = to zoom in
# - or _ to zoom out
# arrow keys to pan (up, down, left, right)
# q or Q to quit
# sorry, does not work in Windows Command Prompt due to lack of UTF-8 support



