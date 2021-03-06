module DotHash
  class Properties
    attr_reader :hash
    alias_method :to_hash, :hash

    def initialize(hash)
      @hash = hash
    end

    def method_missing(key, *args, &block)
      if has_key?(key)
        execute(key, *args, &block)
      else
        super(key, *args, &block)
      end
    end

    def respond_to?(key)
      has_key?(key) or super(key)
    end

    def to_s
      hash.to_s
    end

    def to_json
      hash.to_json
    end

    def [](key)
      get_value(key)
    end

    private

    def has_key?(key)
      hash.has_key?(key.to_sym) or
        hash.has_key?(key.to_s) or
        hash.respond_to?(key)
    end

    def execute(key, *args, &block)
      value = get_value(key)
      return value unless value.nil?
      hash.public_send(key, *args, &block)
    end

    def get_value(key)
      key = hash.has_key?(key.to_s) ? key.to_s : key.to_sym
      value = hash[key]
      return value unless value.is_a?(Hash)
      hash[key] = self.class.new value
    end
  end
end
