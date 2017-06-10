require 'ostruct'

class DeepStruct < OpenStruct
  attr_accessor :keys

  def initialize(hash=nil)
    @table      = {}
    @hash_table = {}
    @keys       = []

    if hash
      hash.each do |k,v|
        @keys << k

        @table[k.to_sym] = (v.is_a?(Hash) ? self.class.new(v) : v)
        @hash_table[k.to_sym] = v

        new_ostruct_member(k)
      end
    end
  end

  def to_h
    @hash_table
  end

end
