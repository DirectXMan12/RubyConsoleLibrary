require './console-main.rb'
include RubyConsoleLibrary

#ConsoleApp.console_size = [80, 40]

a = ConsoleApp.new
#print ControlCode.escape(ControlCode.get_code(:foreground_red))
w = a.wins[0]

w.box 47,20, :foreground_blue
w.refresh

w.structure do 
  textbox 27, [10,5]
  
  button [10,10], :text => 'OK'
  button [27,10], :text => 'Cancel'
end

w.refresh

inrouter = InputRouter.new(w)

inrouter.bindings do
	bind_key(:up_arrow) do
		focus_prev
	end
	bind_key(:down_arrow) do
		focus_next
	end
  
  bind_key(:p) do
    current_control.interact
  end

	bind_key(:enter) do
    if current_control.input_focus
      capture_all_input :until => :escape do
        feed_through 
      end
    else
      current_control.interact
    end
	end
end

instr = ""
while (instr != "`")
	#sleep 4
	#w.write(instr)
	w.refresh
	instr = Utils.getch(false)
	inrouter.handle_input(instr)

end
a.cleanup
