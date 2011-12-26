#!./ruby
require './console-main.rb'
include RubyConsoleLibrary

quit_app = false # predefined so can set later

a = ConsoleApp.new
w = a.wins[0]

w.box 47,20, :foreground_blue
w.refresh

w.structure do 
  t = textbox 27, [10,5]
  
  ok = button [10,10], :text => 'OK'
  cancel = button [27,10], :text => 'Cancel'
  l = label [15, 15], :text => ' '

  cancel.on_press do 
    quit_app = true
  end

  ok.on_press do
    l.text = t.current_text
  end
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

  bind_key(:ctrl_e) do
    quit_app = true
  end

  bind_key(:enter) do
    unless current_control.input_focus then current_control.interact end
  end

  capture_all_input :except => :existing_bindings do
    if current_control.input_focus then feed_through end
  end
end

Utils.noecho
while (!quit_app)
  w.refresh
  instr = Utils.getch(false)
  inrouter.handle_input(instr)
end
Utils.echo
a.cleanup
