module RubyConsoleLibrary
	class Utils
		def Utils.display_array(s_x, s_y)
			ar = Array.new(s_y)
			ar.each_index do |a| 
				ar[a] = Array.new(s_x) 
				ar[a].each_index { |b| ar[a][b] = Array.new(2) } 
			end

			return ar
		end
		
		if WINDOWS == true
			@@windows_f = {}
			@@windows_f[:getch] = Win32API.new("msvcrt","_getch",[],"I")
		end

		def Utils.getch(filter=true)
			is_special_key = false
			if WINDOWS == true
				n = @@windows_f[:getch].Call
				case n
					when 0xE0
						n = @@windows_f[:getch].Call
						is_special_key = true
						c = case n
									when 0x4B then :left_arrow
									when 0x4D then :right_arrow
									when 0x50 then :down_arrow
									when 0x48 then :up_arrow
								end
					when 0x08
						is_special_key = true
						c = :backspace
					when 0x1B
						is_special_key = true
						c = :escape
					when 0x0D
						is_special_key = true
						c = :enter
				end
			else
				begin
					system("stty raw -echo")
					n = STDIN.getbyte
          if n == 27 
            begin
              n2 = STDIN.read_nonblock(1).getbyte(0)
              if n2 == 91
                n = STDIN.getbyte # get the next two bytes
                is_special_key = true
                case n
                when 68
                  c = :left_arrow
                when 65
                  c = :up_arrow
                when 67
                  c = :right_arrow
                when 66
                  c = :down_arrow
                else
                  c = :unrecognized
                end
              end
            rescue IO::WaitReadable
              # is just the escape key
              is_special_key = true
              c = :escape
            end
          elsif n == 127
            is_special_key = true
            c = :backspace
          elsif n == 13
            is_special_key = true
            c = :enter
          end
				ensure
					system("stty -raw echo")
				end
			end

			unless is_special_key
			 	c = " "
				c.setbyte(0,n)
			end
			
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
