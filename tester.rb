require './console-main.rb'
include RubyConsoleLibrary

a = ConsoleApp.new
#print ControlCode.escape(ControlCode.get_code(:foreground_red))
w = a.wins[0]

w.box 10,10, :background_blue
w.refresh

#sleep 10
#gets

#w.box 20,20

w.refresh

t = TextBoxControl.new(w, 5, [10, 4])
w.new_control t
t.enabled = true

q = TextBoxControl.new(w, 7, [10, 12])
w.new_control q
q.enabled = true

w.refresh

inrouter = InputRouter.new(w)

inrouter.bindings do
	bind_key(:up_arrow) do
		focus_prev
	end
	bind_key(:down_arrow) do
		focus_next
	end
	bind_key(:enter) do
		capture_all_input :until => :escape do
			feed_through 
		end
	end
end

instr = ""
while (instr != "x")
	#sleep 4
	#w.write(instr)
	w.refresh
	instr = Utils.getch(false)
	inrouter.handle_input(instr)

end
a.cleanup
