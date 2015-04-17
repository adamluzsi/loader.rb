require 'loader'
module Loader::Helpers

  extend self

  def pwd
    if !!ENV['BUNDLE_GEMFILE']
      ENV['BUNDLE_GEMFILE'].split(File::Separator)[0..-2].join(File::Separator)
    elsif defined?(Rails) && Rails.respond_to?(:root) && Rails.root
      Rails.root.to_s
    else
      Dir.pwd
    end
  end

  # Based on ActiveSupport, removed inflections.
  # https://github.com/rails/rails/blob/v4.1.0.rc1/activesupport/lib/active_support/inflector/methods.rb
  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.gsub('::', '/')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end

end