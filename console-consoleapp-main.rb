module RubyConsoleLibrary
		class ConsoleApp
		@wins = []
		@textoptions = {}
		
		@@console_size = [80,25] #x,y
		def ConsoleApp.console_size
			@@console_size
		end
		def ConsoleApp.console_size= (new_size)
			@@console_size = new_size
		end

		def wins
			@wins
		end
		def wins= (new_wins)
			@wins = new_wins
		end
		
		def ConsoleApp.control_code (code)
			ControlCode.escape code
		end

		def hide_cursor
			print ConsoleApp.control_code "?25l"
		end

		def show_cursor
			print ConsoleApp.control_code "?25h"
		end

		def initialize
			@wins = [ConsoleWin.new(@@console_size)]
			print ControlCode.char_conv (false)
			hide_cursor unless WINDOWS == true
		end

		def cleanup
			show_cursor unless WINDOWS == TRUE
			print ControlCode.escape "0m"
		end

	end
end
