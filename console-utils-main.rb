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
	end
end
