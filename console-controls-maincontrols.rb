require 'console-controls-templatehashes.rb'
module RubyConsoleLibrary
	class TextBoxControl < ConsoleControl		
		@current_text = "" #read, write
		@cursor_loc = 0

		def current_text
			return @current_text
		end

		def current_text=(t)
			@current_text = t.to_s
			local_cursor_x = 1
			@template = self.make_template
			@current_text[display_cursor..display_cursor+@dims[0]-2].each_char do |c|
				if (local_cursor_x < @dims[0]-1)
					@template[1][local_cursor_x] = [:none, c]
					local_cursor_x += 1
				end
				if (@dims[0]-2 < @current_text.length)
					unless (typing_cursor > current_text.length-2)
						unless display_cursor == 0
							@template[1][@dims[0]-1] = [:deco_bold, UI[:nav_scroll_right]]
							@template[1][0] = [:deco_bold, UI[:nav_scroll_left]]
						else
							@template[1][@dims[0]-1] = [:deco_bold, UI[:nav_scroll_right]]
						end
					else
						@template[1][0] = [:deco_bold, UI[:nav_scroll_left]]
					end
				end

				#@template[1][0] = [:deco_bold, (@cursor_loc).to_s]

			end
		end

		def typing_cursor
			unless @cursor_loc+@dims[0]-2 > current_text.length
				@cursor_loc+@dims[0]-3
			else
				unless current_text.length == 0
					current_text.length
				else
					0
				end
			end
		end
		
		def display_cursor
			if current_text.length <= @dims[0]-2
				return 0
			elsif @cursor_loc+@dims[0]-2 > current_text.length
				return current_text.length-(@dims[0]-2)
			else
				#debugger
				#1 == 1
				return @cursor_loc
			end
		end

		def initialize (parent_window, s_x, pos=[1,1])
			super(parent_window, pos)
			@dims = [s_x, 3]
			#@template = Utils.display_array(@dims[0],@dims[1])
			#@template[1][1] = [:none, "!:test_letter"] #for test purposes
			@template = self.make_template
			@interactable = true	
			@current_text = ""
			@cursor_loc = 0
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
			unless owner.key_state[0].class == Symbol 
				#debugger
				self.current_text = current_text[0..typing_cursor] + owner.key_state[0] + unless (current_text[typing_cursor+1..-1].nil?) then self.current_text[typing_cursor+1..-1] else '' end
				@cursor_loc += 1
				self.current_text += ''
			else
				if (@current_text.length > @dims[0]-2)
					case owner.key_state[0]
						when :left_arrow
							unless @cursor_loc == 0 then @cursor_loc -= 1 end 
						when :right_arrow	
							unless @cursor_loc >= @current_text.length then @cursor_loc +=1 end
					end
					self.current_text += ''
				end
				case owner.key_state[0]
					when :backspace
						unless @current_text.length == 1
							if typing_cursor >= @current_text.length-1
								@current_text = @current_text[0..@current_text.length-2]
							else
								@current_text = @current_text[0..typing_cursor-1] + @current_text[typing_cursor+1..-1]
							end
						else
							@current_text = ''
						end
						if ( @cursor_loc+@dims[0]-2 > current_text.length) then @cursor_loc -= 1 end
						self.current_text += ''
				end
			end
			return @state.to_s #success!
		end	
	end
end
