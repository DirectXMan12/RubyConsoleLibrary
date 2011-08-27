module RubyConsoleLibrary
	# this is a utility class for retrieving special ui characters
	class UI
		def UI.[](key)
			c = key.to_s
			cs = c.split('_', 2)
			@@chars[cs[0].to_sym][cs[1].to_sym]
		end
		
		# see char_conv under ControlCode
		def UI.on
			ControlCode.char_conv(true)
		end
		
		def UI.off
			ControlCode.char_conv(false)
		end
	end

	# this is a utility class for retrieving special control characters that determine color
	class ControlCode
		
		# handles the retrieval of a single control code (essentially an alias for ControlCode.get_code)
		def ControlCode.[] (code_name)
			c = code_name
			if (c.is_a?(String)) then c = c.to_sym end
			ControlCode.get_code(c)
		end

		# handles the actual retrieval of a single control code or multiple control codes
		def ControlCode.get_code (code_name)
			if code_name.nil? then return end
			if (!code_name.is_a?(Array) && (code_name.to_sym == :none)) then return "0m" end
			
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

		# renders a set of controle codes for output
		def ControlCode.get_full (code_names_vals)
			if code_names_vals.nil? then return "" end
			if code_names_vals.kind_of?(Symbol) || code_names_vals.kind_of?(String) then code_names_vals = [code_names_vals] end
			codes = ""
			code_names_vals.each_with_index do |code_name,i|
				c = ControlCode[code_name]
				if c == "" then next end
				codes += c	
				codes += ";" unless code_names_vals.length == 1 || i == code_names_vals.length - 1 
			end

			q = codes.delete! "m"
			codes = ControlCode.escape codes
			codes += "m" unless !q
			return codes
		end

		# returns a control code to turn on or off special UI Characters
		def ControlCode.char_conv (on_off)
			if (on_off == true)
				ControlCode.escape "K"
			else
				ControlCode.escape( if (WINDOWS) then "U" else "B" end )
			end
		end
		

		# internal methods
		private
		
		# escapes the code properly according to platform and code length
		def ControlCode.escape (code, use_paren=false)
			if code.length == 1 && WINDOWS != true && use_paren
				"\e(" + code
			else
				"\e[" + code
			end
		end
	end
end
