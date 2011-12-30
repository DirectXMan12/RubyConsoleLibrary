#! /usr/bin/ruby
require './console-main.rb'
include RubyConsoleLibrary

quit_app = false # predefined so can set later

a = ConsoleApp.new

art_size = ConsoleApp.console_size.min-2

w = a.wins[0]

w.box art_size+1, art_size+1, :foreground_blue
w.refresh

ART_SIZE = art_size

module RubyConsoleLibrary
  class CellControl < DropdownControl #ConsoleControl
    def text
      @text
    end

    def text=(t)
      @text = t
      if @text.length > 1 then @text = @text[0] end
      @changed = true
      @redraw = true
      @template = make_template
    end

    def initialize (parent_window, pos=[1,1], opts={})
      @state = :unfocused
      @style = {:blank => :none, :unfocused => :none, :hover => [:background_blue, :deco_negative], :filled => [:foreground_green]}.merge(opts)
      @dims = [1,1]
      super(parent_window, pos, opts.merge({:dd_height => 10, :width => 3}))
      @interactable = true
      @changed = true
      @text = ' '
      @receives_text = true
      @state = :unfocused
      @template = make_template
    end

    def make_template
      raw_template(@style, @state).render(*@dims)
    end

    private
    def raw_template(style, state)
      blank = (@text == ' ' || @text == '' || @text.nil?)
      text_state = if blank then :blank else :filled end
      
      s = if style[state] == :none then [] else style[state].clone end
      s_ts = if style[text_state] == :none then [] else style[text_state].clone end
      s = s | s_ts
      if s.empty? then s = :none end

      if @changed
        @raw_template = ControlTemplate.define do
          line [s, '!:text']
        end
      else
        @raw_template ||= ControlTemplate.define do
          line [s, '!:text']
        end
      end
      @raw_template
    end

    def do_gui(s_x,s_y,state=[:default,:default],opts=nil)
      @gui_array = ConsoleControl.parse_template(@template, {:text => @text || ' '})
      return @gui_array
    end

    def do_hover(type)
      @have_input_focus = (type == :focus)
      @state = if type == :hover or type == :focus then :hover else :unfocused end
      @changed = true
      @redraw = true
      @template = make_template
    end

    def do_interact
      unless @have_input_focus || owner.key_state[0] == nil then return false end # ignore button presses, etc
      if owner.key_state[0] == nil
        super
      elsif owner.key_state[0] == :backspace
        self.text = ' '
      elsif owner.key_state[0].kind_of? String
        self.text = owner.key_state[0]
      end
      return @state.to_s # success!
    end
  end

  class MinbControl < ButtonControl
    def make_template
      d = @dims
      if d[0] == :auto then d[0] = @text.length end # | @text.length |
      raw_template(@colors, @state).render(*d)
    end

    def raw_template(style, k)
      if @old_state != k
        @raw_template = nil
        @old_state = k
      end
     
      @raw_template ||= ControlTemplate.define do
        line exp([style[k][:interior],'!:text'])
      end
    end
  end
end

class String
  def each_char_with_index
    ind = 0
    self.each_char do |c|
      yield(c, ind)
      ind += 1
    end
  end
end

cell_arr = []
w.structure do 
  (2..art_size).each do |row|
    (2..art_size).each do |col|
      cell_arr << (c = cell([row,col]))
      c.dd_win.structure do
        (minb [2,2], :text => UI[:block_full]).on_press do
          c.text = UI[:block_full]
          c.input_router.instance_eval { focus_prev }
        end
      end
    end
  end

  fn_tb = textbox art_size-2, [art_size+5, 10]
  save_button = button [art_size+5, 14], :text => 'Save'
  load_button = button [art_size+19, 14], :text => 'Load'

  save_button.on_press do
    File.open(fn_tb.text, 'w') do |out_file|
      (0..ART_SIZE-2).each do |row|
        (0..ART_SIZE-2).each do |col|
          out_file.syswrite(cell_arr[col*(ART_SIZE-1)+row].text)
        end
        out_file.syswrite("\n")
      end
    end
  end

  load_button.on_press do
    File.open(fn_tb.text, 'r') do |in_file|
      in_file.each_with_index do |l, ln|
        l["\n"] = ''
        l.gsub!(/\s+$/, '') unless l.match(/^\s+$/)
        l.each_char_with_index do |c, cn|
          cell_arr[cn*(ART_SIZE-1)+ln].text = c.to_s
        end
      end
    end
  end
end

def calc_row(ind)
  ind % (ART_SIZE-1)
end

a.refresh

inrouter = InputRouter.new(w)

cell_arr.each do |c|
  c.input_router = inrouter
end

inrouter.bindings do
  bind_key(:up_arrow) do
    focus_prev
  end
  bind_key(:down_arrow) do
    focus_next
  end

  bind_key(:right_arrow) do
    curr_pos = get_focus_pos 
    set_focus (curr_pos + ART_SIZE - 1)
  end

  bind_key(:left_arrow) do
    curr_pos = get_focus_pos
    set_focus (curr_pos - ART_SIZE + 1)
  end

  bind_key(' ') do
    curr_pos = get_focus_pos
    set_focus (curr_pos + ART_SIZE - 1)
  end

  bind_key(:ctrl_e) do
    quit_app = true
  end

  bind_key(:enter) do
    unless current_control.input_focus then current_control.interact end
    if current_control.kind_of? CellControl
      current_control.interact
    end
  end

  capture_all_input :except => :existing_bindings do
    if current_control.input_focus then feed_through end
  end
end

Utils.noecho
while (!quit_app)
  a.refresh
  instr = Utils.getch(false)
  inrouter.handle_input(instr)
end
Utils.echo
a.cleanup
