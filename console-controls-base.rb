module RubyConsoleLibrary
	class ConsoleControl
		@parent_window = nil #internal
		@interactable = true #read
		@gui_array = nil		 #internal, last used gui
		@template	= nil			 #internal
		@enabled = true      #read/write
		@dims = [0,0] #x,y   #internal
		@opts = {}    	     #read/write
		@state = :default		 #read

		def initialize(parent_obj)
			@parent_window = parent_obj
			@opts = {}
			@enabled = true
		end

		def enabled?
			return @enabled
		end
		def enabled
			return @enabled
		end
		def enabled=(val)
			@enabled = val
		end

		def opts
			return @opts
		end
		def opts=(val)
			@opts = val
		end

		def state
			return @state
		end

		def interactable?
			return @interactable
		end

		def interact
			return nil unless @interactable && @enabled 
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

		def ConsoleControl.parse_template(template_array, subs_hash)
			t_t = template_array.deep_copy
			s_h = subs_hash.deep_copy
			#debugger
			s_h.each do |s|
				if s[1].is_a? String
					rev_str = s[1].reverse
					s_h[s[0].to_sym] = []
					rev_str.each_char {|c| s_h[s[0].to_sym].push(c) }
				end
			end
			t_t.each_with_index do |row,row_i|
				row.each_with_index do |col,col_i|
					col.each_with_index do |attr,attr_i|
						if  attr =~ /^!:(.+)/ #places in which require substitutions are in this form: "!:nameof substituion"
							#debugger
							t_t[row_i][col_i][attr_i] = if s_h[$1.to_sym].is_a?(Array)
										s_h[$1.to_sym].pop
									else
										s_h[$1.to_sym]
									end
						end
					end
				end
			end
			return t_t
		end
						
		#internal methods - these should be replaced by actual control methods
		private

		def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
			@state = state[1]
			@gui_array = @template.deep_copy
			return @gui_array #return what is to be displayed (in the form of a display array, as seen in the ConsoleWin class definition
		end		

		def do_interact
			return true #success!
		end
	end
end
