module RubyConsoleLibrary
	class TextBoxControl < ConsoleControl
		
		def initialize (parent_window, s_x,s_y)
			super(parent_window)
			@dims = [s_x, s_y]
			@template = Utils.display_array(@dims[0],@dims[1])
			@template[1][1] = [:none, "h"] #for test purposes	
		end

		#begin private overloaded methods...
		private

		def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
			@state = state[1]
			@gui_array = @template
			return @gui_array

			#debugger	
		end		

		def do_interact
			return true #success!
		end	
	end
end
