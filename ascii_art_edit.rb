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
  class CellControl < ConsoleControl
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
      super(parent_window, pos)
      @style = {:blank => :none, :unfocused => :none, :hover => [:background_blue], :filled => [:foreground_green]}.merge(opts)
      @dims = [1,1]
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
      unless @have_input_focus then return false end # ignore button presses, etc
      if owner.key_state[0] == :enter
        # handle searching for special chars here 
        puts 'hi'
      elsif owner.key_state[0] == :backspace
        self.text = ' '
      elsif owner.key_state[0].kind_of? String
        self.text = owner.key_state[0]
      end
      return @state.to_s # success!
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

w.structure do 
  cell_arr = []
  (2..art_size).each do |row|
    (2..art_size).each do |col|
      cell_arr << cell([row,col])
    end
  end

  fn_tb = textbox art_size-2, [art_size+2, 10]
  save_button = button [art_size+2, 20], :text => 'Save'
  load_button = button [art_size+16, 20], :text => 'Load'

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

w.refresh

inrouter = InputRouter.new(w)

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
  end

  capture_all_input :except => :existing_bindings do
    if current_control.input_focus then feed_through end
  end
end

Utils.noecho
while (!quit_app)
  w.refresh
  instr = Utils.getch(false)
  inrouter.handle_input(instr)
end
Utils.echo
a.cleanup
