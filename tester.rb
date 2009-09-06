require 'console-main.rb'
include RubyConsoleLibrary

a = ConsoleApp.new
print ControlCode.escape(ControlCode.get_code(:foreground_red))
w = a.wins[0]

w.box 10,10

w.refresh

sleep 10

w.box 20,20

w.refresh

gets
a.cleanup
