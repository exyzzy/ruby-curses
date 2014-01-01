
# encoding: UTF-8

require "curses"
include Curses

# def onsig(sig)
#   close_screen
#   exit sig
# end

# def ranf
#   rand(32767).to_f / 32767
# end

# main #
# for i in 1 .. 15  # SIGHUP .. SIGTERM
#   if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
#     trap(i) {|sig| onsig(sig) }
#   end
# end

curs_set(0)
init_screen
nl
noecho
# srand

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
