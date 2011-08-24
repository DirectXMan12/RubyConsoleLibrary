module RubyConsoleLibrary
  class ControlTemplate
    def self.define(&blk)
      template = self.new
      template.instance_eval(&blk)
      return template
    end

    def rr(w=10,h=10)
      render(w,h).each do |l|
        res = l.reduce("") {|acc,ch| acc += ch[1].to_s}
        puts res
      end
    end

    def render(w,h)
      rendered_lines = []
      
      num_expanders = 0
      expander_space = h - @lines.length
      @lines.each do |l|
        if l[0].kind_of?(Hash) && l[0][:type] == :expander && l[0][:direction] == :vert
          num_expanders += 1
          expander_space += 1
        end
      end
      space_per_expander = unless num_expanders == 0 then (expander_space/num_expanders).to_i else 0 end

      @lines.each_with_index do |l,ind|
        if l[0].kind_of?(Hash) && l[0][:type] == :expander && l[0][:direction] == :vert
          space_per_expander.times do |i|
            rendered_lines << _render_line(ind, l, w, h)
          end
        else
          rendered_lines << _render_line(ind, l, w, h)
        end
      end
      return rendered_lines
    end

    private
    def initialize
      @lines = []
    end

    def _render_line(y, line, w, h)
      res = []
      num_expanders = 0
      expander_space = w - line.length

      line.each do |p|
        if p.kind_of?(Hash) && p[:type] == :expander
          expander_space += 1
          num_expanders += 1
        end
      end

      space_per_expander = unless num_expanders == 0 then (expander_space/num_expanders).to_i else 0 end
      
      line.each_with_index do |part,x|
        if part.kind_of?(Hash)
          if part[:type] == :expander # just expander support for now
            case part[:direction]
            when :horiz
              if part[:char].kind_of?(Proc)
                space_per_expander.times do |i|
                  res << part[:char].call(i, space_per_expander)
                end
              else
                space_per_expander.times do |i|
                  res << part[:char]
                end
              end
            when :vert
              _render_line(y, part[:char], w, h).each do |p|
                res << p
              end
            end
          end
        else
          res << part
        end
      end

      return res
    end

    def parse_line(*parts)
      line = []
      parts.each do |p|
        if p.kind_of? String # just a plain String
          p.each_char {|c| line << [:none,c] }
        elsif p.kind_of? Hash # an expander or other special char
          line << p
        elsif p.kind_of? Array # just a normal [style, char] pair
          line << p 
        end
      end
      return line
    end
    
    def line(*parts)
      @lines << parse_line(*parts)
    end

    def exp(params)
      if params.kind_of? Hash # a full, complex expander
        expand_opts = {:min => params[:min] || 1, :max => params[:max] || :inf}
        direction = :horiz
        char = [:none,:none]
        unless params[:v] || params[:vert]
          opts = params[:h] || params[:horiz]
          direction = :horiz
          if opts[:sequence]
            if opts[:sequence].reduce(false) {|acc,obj| acc = (obj.kind_of?(Array) && obj.length % 2 != 0) || acc} # special sequence
              filled_start = false
              start_const = []
              end_const = []
              middle_seq = []
              opts[:sequence].each do |ch|
                if ch.kind_of?(Array) && (ch.length != 2 || ch[0].kind_of?(Array))
                  filled_start = true
                  middle_seq = ch
                elsif filled_start
                  end_const << ch
                else
                  start_const << ch
                end
              end

              char = Proc.new do |index,max|
                if index < start_const.length
                  if start_const[index].kind_of?(Array) then start_const[index] else [:none, start_const[index]] end
                elsif (max - index - 1) < end_const.length
                  ind = end_const.length - max + index
                  if end_const[ind].kind_of?(Array) then end_const[ind] else [:none, end_const[ind]] end
                else
                  ind = (index-start_const.length) % middle_seq.length
                  if middle_seq[ind].kind_of?(Array) then middle_seq[ind] else [:none, middle_seq[ind]] end
                end
              end
            else # normal sequence
              seq = opts[:sequence]
              char = Proc.new do |index,len|
                ind = index % seq.length
                if seq[ind].kind_of?(Array) then seq[ind] else [:none, seq[ind]] end
              end
            end
          else
            char = if opts[:char].kind_of?(Array) then opts[:char] else [:none,opts[:char]] end
          end
        else
          opts = params[:v] || params[:vert]
          direction = :vert
          char = parse_line(*opts)
        end
        {:type => :expander, :direction => direction, :char => char}
      elsif opts.kind_of? Array # [style, char] pair
        {:type => :expander, :direction => :horiz, :char => params}
      else # just a character
        {:type => :expander, :direction => :horiz, :char => [:none, params]}
      end
    end
  end
end
