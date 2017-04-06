module CacheHelper
  VERSION = "1.0.0"

  def self.simple_cache(klass, selector, key, value)
    klass.where(selector).pluck(key, value).to_h
  end

  def self.key_to_object_cache(klass, selector, key)
    klass.where(selector).map {|object| [object.send(key), object]}.to_h
  end

  def self.key_to_objects_cache(klass, selector, key)
    return compound_key_to_objects_cache(klass, selector, key) if key.is_a?(Array)
    simple_key_to_objects_cache(klass, selector, key)
  end

  def self.key_presence_cache(klass, selector, key)
    return compound_key_presence_cache(klass, selector, key) if key.is_a?(Array)
    simple_key_presence_cache(klass, selector, key)
  end

  private

  def self.simple_key_to_objects_cache(klass, selector, key)
    objects = klass.where(selector)
    objects.each_with_object(Hash.new { |h, k| h[k] = [] }) do |object, res|
      res[object.send(key)] << object
    end
  end

  def self.compound_key_to_objects_cache(klass, selector, keys_array)
    objects = klass.where(selector)
    objects.each_with_object(Hash.new { |h, k| h[k] = [] }) do |object, res|
      key = keys_array.map{ |k| object.send(k) }
      res[key] << object
    end
  end

  def self.simple_key_presence_cache(klass, selector, key)
    klass.where(selector).pluck(key).compact.uniq.map {|object| [object, true]}.to_h
  end

  def self.compound_key_presence_cache(klass, selector, keys_array)
    klass.where(selector).pluck(*keys_array).map do |object|
      [object, true]
    end.to_h
  end
end
