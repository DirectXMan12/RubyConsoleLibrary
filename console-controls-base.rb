module RubyConsoleLibrary
	class ConsoleControl
		@parent_window = nil #internal
		@interactable = true #read
		@gui_array = nil		 #internal, last used gui
		@template	= nil			 #internal
		attr_reader :enabled #read/write
		@dims = [0,0] #x,y   #internal
		attr_reader :opts		 #read/write
		@state = :default		 #read

		def initialize(parent_obj)
			@parent_window = parent_obj
			@opts = {}
		end

		def state
			return @state
		end

		def interactable?
			return @interactable
		end

		def interact
			return nil unless @interactable || !@enabled
			do_interact
		end
		
		def draw (d_opts={})
			all_opts = @opts.merge d_opts
			new_state = if  d_opts[:new_state]
										d_opts[:new_state]
									else
										:default
									end
			return do_gui(@dims[0],@dims[1], [@state,new_state], all_opts)
		end

		def ConsoleControl.parse_template(t_array, subs_hash)
			t_a = t_array
			s_h = subs_hash
			s_h.each do |s|
				if s[1].is_a? String
					rev_str = s[1].reverse
					s_h[s[0].to_sym] = []
					rev_str.each_char {|c| s_h[s[0].to_sym].push(c) }
				end
			end
			t_a.each_with_index do |row,row_i|
				row.each_with_index do |col,col_i|
					col.each_with_index do |attr,attr_i|
						if  attr =~ /^!:(.+)/ #places in which require substitutions are in this form: "!:nameof substituion"
							#debugger
							t_a[row_i][col_i][attr_i] = if s_h[$1.to_sym].is_a?(Array)
										s_h[$1.to_sym].pop
									else
										s_h[$1.to_sym]
									end
						end
					end
				end
			end
			return t_a
		end
						
		#internal methods - these should be replaced by actual control methods
		private

		def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
			@state = state[1]
			@gui_array = @template
			return @gui_array #return what is to be displayed (in the form of a display array, as seen in the ConsoleWin class definition
		end		

		def do_interact
			return true #success!
		end
	end
end
