class String
  def to_display_array(style=:none)
    res = []
    self.each_char do |c|
      res << [style, c]
    end
    res
  end
end
