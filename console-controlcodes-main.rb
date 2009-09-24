module RubyConsoleLibrary
	class ControlCode
		def ControlCode.escape (code)
			if code.length == 1 && WINDOWS != true
				"\e(" + code
			else
				"\e[" + code
			end
		end

		def ControlCode.text_codes
			@@text
		end
		
		def ControlCode.cursor_codes
			@@cursor
		end

		def ControlCode.get_code (code_name)
			if code_name.nil? then return end
			if (!code_name.is_a?(Array) && (code_name.to_sym == :none)) then return ControlCode.escape "0m" end

			a = false
			c = nil
			cs = nil
			as = nil

			if code_name.is_a?(Array)
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
			r = l[cs[1].to_sym].dup
			
			if a == true
				as.each do |n|
					r.sub!("val", n.to_s)
				end
			end

			return r
		end
	
		def ControlCode.get_full (code_names_vals)
			if code_names_vals.nil? then return "" end
			if code_names_vals.class == Symbol || code_names_vals.class == String then code_names_vals = [code_names_vals] end
			codes = ""
			code_names_vals.each_with_index do |code_name,i|
				c = ControlCode.get_code code_name
				if c == "" then next end
				codes += c	
				codes += ";" unless code_names_vals.length == 1 || i == code_names_vals.length - 1 
			end

			q = codes.delete! "m"
			codes = ControlCode.escape codes
			codes += "m" unless !q
			return codes
		end

		def ControlCode.char_conv (on_off)
			if (on_off == true)
				ControlCode.escape "K"
			else
				ControlCode.escape "U" #windows, or "B" for Linux
			end
		end
	end
end
