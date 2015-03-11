class Array
  def to_sql_values
    tmp = self.map do |elem|
      if elem.nil?
        'NULL'
      else
        "'#{elem}'"
      end
    end
    "#{tmp.join(', ')}"
  end

  def to_sql_columns
    "`#{self.join('`, `')}`"
  end
end