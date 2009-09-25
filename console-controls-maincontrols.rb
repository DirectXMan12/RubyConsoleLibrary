module RubyConsoleLibrary
	class TextBoxControl < ConsoleControl
		
		def initialize (parent_window, s_x,s_y)
			super(parent_window)
			@dims = [s_x, s_y]
			@template = Utils.display_array(@dims[0],@dims[1])
			@template[1][1] = [:none, "!:test_letter"] #for test purposes
			@interactable = true	
		end

		#begin private overloaded methods...
		private

		def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
			#@state = state[1]
			tl = case @state
					 when :default
						 'def'
					 when :open
						 'open'
					 else
						 'none'
					 end
			@gui_array = ConsoleControl.parse_template(@template, {:test_letter => tl})
			return @gui_array

			#debugger	
		end		

		def do_interact
			@state = :open
			return @state.to_s #success!
		end	
	end
end
