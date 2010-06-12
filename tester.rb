require 'console-main.rb'
include RubyConsoleLibrary

a = ConsoleApp.new
#print ControlCode.escape(ControlCode.get_code(:foreground_red))
w = a.wins[0]

w.box 10,10, :background_blue
w.refresh

#sleep 10
gets

w.box 20,20

w.refresh

t = TextBoxControl.new(w, 5, 3)
w.display_obj t.draw

w.refresh

instr = ""
while (instr != "x")
	#sleep 4
	#w.write(instr)
	w.refresh
	instr = Utils.getch

	t.enabled = true
	t.interact

	w.display_obj t.draw
end
a.cleanup
