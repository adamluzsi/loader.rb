class Array

  # remove n. element from the end
  # and return a new object
  def pinch n=1
    return self[0..(self.count-(n+1))]
  end unless method_defined? :pinch

  # remove n. element from the end
  # and return the original object
  def pinch! n=1
    n.times do
      self.pop
    end
    return self
  end unless method_defined? :pinch!

  # return boolean by other array
  # all element included or
  # not in the target array
  def contain?(oth_array)#anothere array
    (oth_array & self) == oth_array
  end unless method_defined? :contain?
  alias :contains? :contain? unless method_defined? :contain?

  # generate params structure from array
  # return_array
  def extract_class! class_name

    if class_name.class != Class
      raise ArgumentError, "parameter must be a class name"
    end

    return_value= self.map { |element|
      if element.class == class_name
        element
      end
    }.uniq - [ nil ]
    return_value.each{|e| self.delete(e) }

    return return_value

  end unless method_defined? :extract_class!

end