module Loader
  module  ArrayEXT

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
end

Array.__send__ :include, Loader::ArrayEXT