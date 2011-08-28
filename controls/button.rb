module RubyConsoleLibrary
	class ButtonControl < ConsoleControl		
		def initialize (parent_window, pos, attrs={})
      opts = {:pressed => {:border => [:foreground_brightgreen, :deco_bold], :interior => :deco_bold}, :released => {:border => :foreground_white, :interior => :none}, :hover => {:interior => :deco_bold, :border => :none}, :keeps_state => true, :state => :released, :text => 'Button', :width => :auto, :height => 3}.merge(attrs)
			super(parent_window, pos)
			@dims = [opts[:width], opts[:height]]
			@interactable = true
      @keeps_state = opts[:keeps_state]
      @state = opts[:state]
      @old_state = nil

      @colors = {:pressed => opts[:pressed], :released => opts[:released], :hover => opts[:hover]}
      @colors.each do |k,v|
        unless v.kind_of?(Array) || v.kind_of?(Hash)
          @colors[k] = {}
          @colors[k][:interior] = 'background_'+v.to_s
          @colors[k][:border] = :none
        end
      end

      @text = opts[:text]
			@template = self.make_template
		end


    def make_template
      d = @dims
      if d[0] == :auto then d[0] = @text.length + 4 end # | @text.length |
      raw_template(@colors, @state).render(*d)
    end
		#begin private overloaded methods...
		private

    def raw_template(style, k)
      if @old_state != k
        @raw_template = nil
        @old_state = k
      end

      @raw_template ||= ControlTemplate.define do
        line [style[k][:border], UI[:line_corner_top_left]], exp([style[k][:border], UI[:line_bottom]]), [style[k][:border], UI[:line_corner_top_right]]
        line [style[k][:border], UI[:line_side]], [style[k][:interior], ' '], exp([style[k][:interior],'!:text']), [style[k][:interior], ' '], [style[k][:border], UI[:line_side]]
        line [style[k][:border], UI[:line_corner_bottom_left]], exp([style[k][:border], UI[:line_bottom]]), [style[k][:border], UI[:line_corner_bottom_right]]
      end
    end

		def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
			@gui_array = ConsoleControl.parse_template(@template, {:text => @text})
			return @gui_array
		end		

    def do_hover(type=:hover)
      @state = if type == :hover then :hover else :released end
      @template = self.make_template
      return @state.to_s
    end

		def do_interact
      @state = if @state == :pressed then :released else :pressed end
      @template = self.make_template
			return @state.to_s #success!
		end	
	end
end
