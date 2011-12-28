module RubyConsoleLibrary
  class TextBoxControl < ConsoleControl

    def text
      @text
    end

    def text=(t)
      @text = t.to_s
      @changed = true
      @redraw = true
      @template = make_template
    end

    def typing_cursor
      @typing_cursor
    end

    def typing_cursor=(pos)
      @typing_cursor = pos
      if (pos > @text.length)
        @typing_cursor = @text.length
      elsif (pos < 0)
        @typing_cursor = 0
      end
      
      if (@typing_cursor < @display_cursor)
        self.display_cursor -= @display_cursor - pos
      elsif (@typing_cursor > @display_cursor + @dims[0] - 3)
        self.display_cursor += @typing_cursor - @display_cursor - @dims[0] + 3
      end
    end

    def display_cursor
      @display_cursor
    end

    def display_cursor=(pos)
      @display_cursor = pos
      if @display_cursor + @dims[0] - 2 > @text.length then @display_cursor = @text.length - @dims[0] + 2 end
      if @display_cursor < 0 then @display_cursor = 0 end
      @changed = true
      @redraw = true
      @template = make_template
    end

    def initialize (parent_window, s_x, pos=[1,1])
      super(parent_window, pos)
      @dims = [s_x, 3]
      @interactable = true
      @changed = true
      @text = ""
      @display_cursor = 0
      @typing_cursor = 0
      @receives_text = true
      @template = make_template
    end

    def make_template
      raw_template(if @state == :hover then [:deco_bold, :foreground_brightwhite] else :none end).render(*@dims)
    end

    # begin private overloaded methods
    private
    def raw_template(style)
      @current_ui_style ||= style
      me = self
      unless @current_ui_style == style && !@changed
        @current_ui_style = style
        @changed = false
        @raw_template = ControlTemplate.define do
          line [style, UI[:line_corner_top_left]], exp([style, UI[:line_bottom]]), [style, UI[:line_corner_top_right]]
          line [style, unless me.display_cursor > 0 then UI[:line_side] else UI[:nav_scroll_left] end], exp('!:text'), [style, unless me.text.length - me.display_cursor > me.dims[0] - 2 then UI[:line_side] else UI[:nav_scroll_left] end]
          line [style, UI[:line_corner_bottom_left]], exp([style, UI[:line_bottom]]), [style, UI[:line_corner_bottom_right]]
        end
      else
        @raw_template ||= ControlTemplate.define do
          line [style, UI[:line_corner_top_left]], exp([style, UI[:line_bottom]]), [style, UI[:line_corner_top_right]]
          line [style, unless me.display_cursor > 0 then UI[:line_side] else UI[:nav_scroll_left] end], exp('!:text'), [style, unless me.text.length - me.display_cursor > me.dims[0] - 2 then UI[:line_side] else UI[:nav_scroll_left] end]
          line [style, UI[:line_corner_bottom_left]], exp([style, UI[:line_bottom]]), [style, UI[:line_corner_bottom_right]]
        end
      end
    end

    def do_gui(s_x,s_y,state=[:default,:default],opts=nil)
      @gui_array = ConsoleControl.parse_template(@template, {:text => @text[display_cursor..-1]})
    end

    def do_hover(type)
      @have_input_focus = (type == :focus)
      @state = if type == :hover or type == :focus then :hover else :unfocused end
      unless @text.nil? then self.text += '' else self.text = '' end
    end

    def do_interact
      unless @have_input_focus then return false end # ignore button presses, etc
      unless owner.key_state[0].class == Symbol
        self.text = self.text[0..self.typing_cursor-1] + owner.key_state[0] + (unless self.text[self.typing_cursor..-1].nil? then self.text[self.typing_cursor..-1] else '' end)
        self.typing_cursor += 1
      else
        case owner.key_state[0]
        when :left_arrow
          self.typing_cursor -= 1
        when :right_arrow
          self.typing_cursor += 1
        when :backspace
          unless text == '' || self.typing_cursor == 0
            @text[self.typing_cursor-1] = ''
            self.typing_cursor -= 1
            self.display_cursor = self.display_cursor # force display cursor refresh
            text = @text
          end
        end
      end
      return @state.to_s # success!
    end
  end
end
