module RubyConsoleLibrary
  class LabelControl < ConsoleControl
    def initialize(parent_window, pos, attrs={})
      opts = { :hover => {:interior => :foreground_brightblue, :border => :none}, :default => {:interior => :none, :border => :none}, :show_border => false, :width => :auto, :height => 1, :text => "label"}.merge(attrs)
      super(parent_window, pos)

      @dims = [opts[:width], opts[:height]]
      @text = opts[:text]
      @interactable = false
      @show_border = opts[:show_border]
      @changed = true # update template?
      
      @colors = {:default => opts[:default], :hover => opts[:hover]}
      @colors.each do |k,v|
        unless v.kind_of?(Array) or v.kind_of?(Hash)
          @colors[k] = {}
          @colors[k][:interior] = 'background_'+v.to_s
          @colors[k][:border] = :none
        end
      end

      @state = :default
      @old_state = :default
      @old_dims = [0,0]
      @template = make_template
    end

    def text
      @text
    end

    def text=(t)
      @text = t
      @changed = true
      @template = make_template
      @redraw = true
      @text
    end

    def make_template
      d = @dims.clone
      if @dims[0] == :auto then d[0] = @text.length + (if @show_border then 4 else 0 end) end
      if @dims[1] == 1 and @show_border then d[1] += 2 end
      @state ||= :default
      if d[0] < @old_dims[0] || d[1] < @old_dims[1]
        sp = (ControlTemplate.define do
          line exp(:v => [exp(' ')])
        end)
        
        buf = sp.render(*@old_dims)
        owner.force_write_delta @loc.map { |i| i - 1 }, buf
        #if @loc[0].kind_of?(Symbol) || @loc[1].kind_of?(Symbol) || @old_dims[0].kind_of?(Symbol) || @old_dims[1].kind_of?(Symbol)
        #  raise "#{@loc.inspect}, #{@old_dims.inspect}"
        #end
        #owner.parent_app.erase_region(@loc, @old_dims)
      end
      @old_dims = d.clone
      raw_template(@colors,@state).render(*d)
    end

    private
    def raw_template(style,k)
      if @changed
        @changed = false
        @raw_template = nil
      end

      if @show_border
        @raw_template ||= ControlTemplate.define do
          line [style[k][:border], UI[:line_corner_top_left]], exp([style[k][:border], UI[:line_bottom]]), [style[k][:border], UI[:line_corner_top_right]]
          line [style[k][:border], UI[:line_side]], [style[k][:interior], ' '], exp([style[k][:interior],'!:text']), [style[k][:interior], ' '], [style[k][:border], UI[:line_side]]
          line [style[k][:border], UI[:line_corner_bottom_left]], exp([style[k][:border], UI[:line_bottom]]), [style[k][:border], UI[:line_corner_bottom_right]]
        end
      else
        @raw_template ||= ControlTemplate.define do
          line exp([style[k][:interior], '!:text'])
        end
      end
    end

    def do_gui(s_x,s_y, state=[:default,:default], opts=nil)
     @gui_array = ConsoleControl.parse_template(@template, {:text => @text})
     return @gui_array
    end

    def do_hover(type=:hover)
     @state = if type == :hover then :hover else :default end
     @changed = true
     @template = make_template
     @redraw = true
     @state.to_s
    end

    def do_interact
      @state ||= :hover
      @template = make_template
      return @state.to_s
    end
  end
end
