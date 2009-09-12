module RubyConsoleLibrary
	class UICharacters
		def UICharacters.get (ch_name)
			c = ch_name.to_s
			cs = c.split('_', 2)
			@@chars[cs[0].to_sym][cs[1].to_sym]
		end
	end
end
