require 'win32console'
require 'ruby-debug'
require 'console-controlcodes-hashes.rb'
require 'console-UIChars-hashes.rb'

module RubyConsoleLibrary
	class UICharacters
		def UICharacters.get (ch_name)
			c = ch_name.to_s
			cs = c.split('_', 2)
			@@chars[cs[0].to_sym][cs[1].to_sym]
		end
	end
	class ControlCode
		def ControlCode.escape (code)
			"\e[" + code
		end

		def ControlCode.text_codes
			@@text
		end
		
		def ControlCode.cursor_codes
			@@cursor
		end

		def ControlCode.get_code (code_name)
			a = false
			c = nil
			cs = nil
			as = nil

			if code_name.class == Array.class
				a = true

				as = code_name[1..code_name.length-1]
				c = code_name[0].to_s
				cs = c.split '_'
			else
				c = code_name.to_s
				cs = c.split '_'
			end
			#debugger
			l = case cs[0]
						when 'foreground'
							@@text[:colors][:foreground]
						when 'background'
							@@text[:colors][:background]
						when 'deco'
							@@text[:decorations]
						when 'cursor'
							@@cursor[:movement]
						when 'clear'
							@@cursor[:clearing]
					end
			r = l[cs[1].to_sym]
			
			if a == true
				as.each do |n|
					r.sub!("val", n)
				end
			end

			return r
		end
	
		def ControlCode.get_full (code_names_vals)
			codes = ""
			code_names_vals.each do |code_name|
				codes += ControlCode.get_one code_name
				codes += ";" unless code_names.length == 1
			end

			codes = ControlCode.escape codes
			
			return codes
		end

		def ControlCode.char_conv (on_off)
			if (on_off == true)
				ControlCode.escape "K"
			else
				ControlCode.escape "U"
			end
		end
	end
	
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
			#hide_cursor
		end

		def cleanup
			#show_cursor
			print ControlCode.escape "0m"
		end

	end

	class ConsoleWin
		@dims = [0,0] #x,y
		@buffer = []
		@cursor = [0,0]

		def cls
			print ConsoleApp.control_code "2J"
		end

		def initialize (size)
			@dims = size
			@buffer = Array.new(@dims[1]-1)
			@buffer.each_index { |a| @buffer[a] = Array.new(@dims[0]-1) }
			@cursor = [0,0]
		end	
		
		def dims
			@dims
		end
		def dims= (new_dims)
			@dims = new_dims
		end

		def refresh
			cls
			o = ""	
			s = StringIO.new o
			@buffer.each do |l|
				l.each do |c|
					if !c.nil? 
						s.print c
					else
						s.print ' '
					end
				end
				s.print "\n"
			end

			print o
		end

		def box(s_x,s_y)
			#debugger
			for l in @cursor[1]..(s_y - 1)
				if l == @cursor[1]
					@buffer[l][@cursor[0]] = UICharacters.get(:window_corner_top_left)
				elsif l == s_y -1
					@buffer[l][@cursor[0]] = UICharacters.get(:window_corner_bottom_left)
				else
					@buffer[l][@cursor[0]] = UICharacters.get(:window_side)
				end
				
				#debugger
				if l == 0 || l == s_y-1
					#debugger
					(s_x-2).times { |c| @buffer[l][@cursor[0]+c+1] = "\xCD"}
				end
				
				if l == @cursor[1]
					@buffer[l][@cursor[0]+(s_x - 1)] = UICharacters.get(:window_corner_top_right)
				elsif l == s_y - 1
					@buffer[l][@cursor[0]+(s_x - 1)] = UICharacters.get(:window_corner_bottom_right)
				else
					@buffer[l][@cursor[0]+(s_x - 1)] = UICharacters.get(:window_side)
				end
			end
		end
	end
end
