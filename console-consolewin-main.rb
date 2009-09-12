require 'ruby-debug'
module RubyConsoleLibrary
	

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
			@buffer.each_index do |a| 
				@buffer[a] = Array.new(@dims[0]-1) 
				@buffer[a].each_index { |b| @buffer[a][b] = Array.new(2) } #tuple in format [{text_options}, 'character'] 
			end
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
					if !c.nil? && !c[1].nil? 
						s.print ControlCode.get_full(c[0]) unless c[0] == :none
						s.print c[1]
						s.print ControlCode.escape "0m" unless c[0] == :none
					else
						s.print ' '
					end
				end
				s.print "\n"
			end
			#debugger
			print o
		end

		def box(s_x,s_y, text_opts=:none)
			#debugger
			#check for edge overflow - need to write code to check for edge underflow
			if s_x + @cursor[0] > @dims[0]
				s_x = @dims[0] - @cursor[0]
			end
			if s_y + @cursor[1] > @dims[1]
				s_y = @dims[1] - @cursor[1]
			end

			for l in @cursor[1]..(s_y - 1)
				if l == @cursor[1]
					@buffer[l][@cursor[0]] = [text_opts,UICharacters.get(:window_corner_top_left)]
				elsif l == s_y -1
					@buffer[l][@cursor[0]] = [text_opts,UICharacters.get(:window_corner_bottom_left)]
				else
					@buffer[l][@cursor[0]] = [text_opts,UICharacters.get(:window_side)]
				end
				
				#debugger
				if l == 0 || l == s_y-1
					#debugger
					(s_x-2).times { |c| @buffer[l][@cursor[0]+c+1] = [text_opts,UICharacters.get(:window_bottom)]}
				end
				
				if l == @cursor[1]
					@buffer[l][@cursor[0]+(s_x - 1)] = [text_opts,UICharacters.get(:window_corner_top_right)]
				elsif l == s_y - 1
					@buffer[l][@cursor[0]+(s_x - 1)] = [text_opts,UICharacters.get(:window_corner_bottom_right)]
				else
					@buffer[l][@cursor[0]+(s_x - 1)] = [text_opts,UICharacters.get(:window_side)]
				end
			end
		end
	end
end
