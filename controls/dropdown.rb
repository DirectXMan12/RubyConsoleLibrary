module RubyConsoleLibrary
  class DropdownControl < ConsoleControl    
    def initialize (parent_window, pos, attrs={})
      opts = {:default => :none, :hover => [:deco_bold], :keeps_state => true, :state => :default, :text => 'Dropdown', :width => :auto, :height => 1, :dd_height => 4}.merge(attrs)
      super(parent_window, pos)

      @dims ||= [opts[:width], opts[:height]]
      @text = opts[:text]
      @interactable = true
      @keeps_state = opts[:keeps_state]
      @state ||= opts[:state]
      @old_state = nil
      @dd_height = opts[:dd_height]

      @colors = {:default => opts[:default], :hover => opts[:hover]}
      @template = self.make_template

      # create dropdown window
      w = if @dims[0] == :auto then @text.length + 2 else opts[:width] end
      @dd_win = PopupWin.new([w, @dd_height])
      @dd_win.box w, @dd_height, [:foreground_red, :deco_bold]
      @dd_win.loc = [@loc[0]-1, @loc[1]]
      parent_window.parent_app.add_win @dd_win
      @dd_win.deactivate

      @input_router = nil
    end
    
    attr_accessor :dd_win
    attr_accessor :input_router

    def make_template
      d = @dims
      if d[0] == :auto then d[0] = @text.length + 2 end # | @text.length |
      raw_template(@colors, @state).render(*d)
    end

    private
    def raw_template(style, k)
      if @old_state != k
        @raw_template = nil
        @old_state = k
      end

      @raw_template ||= ControlTemplate.define do
        line exp([style[k],'!:text']), [style[k], ' '], [style[k], UI[:nav_scroll_down]]
      end
    end

    def do_gui(s_x,s_y, state=[:default,:default],opts=nil)
      @gui_array = ConsoleControl.parse_template(@template, {:text => @text})
      return @gui_array
    end   

    def do_hover(type=:hover)
      @state = if type == :hover then :hover else :released end
      @template = self.make_template
      @redraw = true
      return @state.to_s
    end

    def do_interact
      @template = self.make_template
      @redraw = true
      if @dd_win.active?
        @dd_win.deactivate 
        @input_router.free_control_list
      else 
        @dd_win.activate
        @input_router.assume_control_list (@dd_win._control_stack | [self])
      end
      return @state.to_s #success!
    end 
  end
end
