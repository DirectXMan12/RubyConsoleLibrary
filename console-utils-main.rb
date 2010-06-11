module RubyConsoleLibrary
	class Utils
		def Utils.display_array(s_x, s_y)
			ar = Array.new(s_y-1)
			ar.each_index do |a| 
				ar[a] = Array.new(s_x-1) 
				ar[a].each_index { |b| ar[a][b] = Array.new(2) } 
			end

			return ar
		end
		
		if WINDOWS == true
			@@windows_f = {}
			@@windows_f[:getch] = Win32API.new("msvcrt","_getch",[],"I")
		end

		def Utils.getch(e=false,filter=true)
			
			if WINDOWS == true
				n = @@windows_f[:getch].Call
			else
				begin
					system("stty raw -echo")
					n = STDIN.getc
				ensure
					system("stty -raw echo")
				end
			end

			c = " "
			c.setbyte(0,n)
			
			if filter == true && (n > 122 || n < 97)
				c = ""
			end	

			return c
		end

	end
end

class Object
	def deep_copy
		return Marshal.load(Marshal.dump(self))
	end
end
