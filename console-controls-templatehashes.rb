# handles the creation of dynamically resizable templates
module RubyConsoleLibrary
	class TextBoxControl < ConsoleControl
		def make_template
			t = Utils.display_array(@dims[0],@dims[1])
			
			t.each_with_index do |row,i|
				unless (i == 0 or i == @dims[1]-1) # unless it's the top or bottom row
				 	row[0] = [:deco_bold, UI[:line_side]]
					row[@dims[0]-1] = [:deco_bold, UI[:line_side]] 
				end	
			end
			
			t[0].each_with_index do |col,i|
				unless (i == 0 or i == @dims[0]-1)
					t[0][i] = [:deco_bold, UI[:line_bottom]]
				end
			end

			t[@dims[1]-1].each_with_index do |col,i|
				unless (i == 0 or i == @dims[0]-1)
					t[@dims[1]-1][i] = [:deco_bold, UI[:line_bottom]]
				end
			end

			# now assign the corners
			t[0][0] = [:deco_bold, UI[:line_corner_top_left]]
			t[0][@dims[0]-1] = [:deco_bold, UI[:line_corner_top_right]]
			t[@dims[1]-1][0] = [:deco_bold, UI[:line_corner_bottom_left]]
			t[@dims[1]-1][@dims[0]-1] = [:deco_bold, UI[:line_corner_bottom_right]]

			return t
		end
	end
end
