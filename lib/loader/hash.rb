module Loader
  module HashEXT
    class << self

      def deep_merge(self_hash,other_hash)
        deep_merge!(self_hash.dup,other_hash)
      end

      def deep_merge!(self_hash,other_hash)
        other_hash.each_pair do |k,v|
          tv = self_hash[k]
          self_hash[k] = tv.is_a?(::Hash) && v.is_a?(::Hash) ? deep_merge(tv,v) : v
        end
        self_hash
      end

    end
  end
end