module RubyConsoleLibrary
	class TextBoxControl < ConsoleControl
		
		@current_text = "" #read, write

		def current_text
			return @current_text
		end
		def current_text=(t)
			@current_text = t.to_s
			local_cursor_x = 1
			@current_text.each_char do |c|
				if (local_cursor_x < @dims[0])
					@template[1][local_cursor_x] = [:none, c]
					local_cursor_x += 1
				else
					@template[1][@dims[0]-1] = [:deco_bold, '>']
				end
			end
		end

		def initialize (parent_window, s_x,s_y)
			super(parent_window)
			@dims = [s_x, s_y]
			@template = Utils.display_array(@dims[0],@dims[1])
			@template[1][1] = [:none, "!:test_letter"] #for test purposes
			@interactable = true	
			@current_text = ""
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
			self.current_text += "x"
			return @state.to_s #success!
		end	
	end
end
