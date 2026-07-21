require_relative "cryolite/version"

module Cryolite
  # This is how runing under Crystal can be detected.
  COMPILED_BY_CRYSTAL = (((1 / 2) * 2) != 0)

  # Monkey-patch Ruby to make it recognize the Crystal's .to_i128 method
  class ::Integer def to_i128() to_i end end

  # An 8-bit zero constant to hint the use of UInt8 instead of Int32 for Crystal
  U8_0 = "\0".bytes.first

  # A 64-bit zero constant to hint the use of Int64 instead of Int32 for Crystal
  I64_0 = (0x3FFFFFFFFFFFFFFF & 0)

  # A 128-bit zero constant to hint the use of Int128 instead of Int32 for Crystal
  I128_0 = 0.to_i128

  # This is a Ruby-compatible trick to create a Crystal's lightweight tuple
  def tuple2(a, b) return a, b end
  def tuple3(a, b, c) return a, b, c end

  # This icky blob of code aliases the Ruby's "respond_to?" method to "responds_to?",
  # making it easier to maintain the source level compatibility with Crystal. And
  # also provides access to the "eval_if_run_by_ruby" function, which does "eval"
  # when the code is run by Ruby, but does nothing when the code is compiled by
  # Crystal. It can be used to define additional aliases necessary for Ruby/Crystal
  # compatibility.
  module ::Kernel def method_missing(name, *args) true end end
  if (k5324534 = ::Kernel).responds_to? :eval ; k5324534.eval "class ::Object alias
  responds_to? respond_to? end ; module ::Kernel undef method_missing end" end
  def self.eval_if_run_by_ruby(src) if (k = ::Kernel).responds_to? :eval ; k.eval src end end
  # See https://bugs.ruby-lang.org/issues/13551#note-3
  eval_if_run_by_ruby "module ::Kernel def alias_singleton_method(new_name, old_name)
  singleton_class.class_exec { alias_method new_name, old_name } end end"
  # A convenient wrapper
  def self.ruby_class_method_alias(classname, from, to) eval_if_run_by_ruby "class
  #{classname} alias_singleton_method :#{to}, :#{from} end" end

  # Emulate "File.exists?" for Ruby 3.2.0 and newer, see
  # https://www.reddit.com/r/ruby/comments/1196wti/psa_and_a_little_rant_fileexists_direxists
  ruby_class_method_alias("::File", "exist?", "exists?")
  # Emulate the availability of Crystal's Regex for Ruby (the name is slightly off)
  eval_if_run_by_ruby "Regex = Regexp"
end

Object.include(Cryolite)
