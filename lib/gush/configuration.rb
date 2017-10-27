module Gush
  class Configuration
    attr_accessor :concurrency, :namespace, :redis_url, :redis_sentinels

    def self.from_json(json)
      new(Gush::JSON.decode(json, symbolize_keys: true))
    end

    def initialize(hash = {})
      self.concurrency     = hash.fetch(:concurrency, 5)
      self.namespace       = hash.fetch(:namespace, 'gush')
      self.redis_url       = hash.fetch(:redis_url, 'redis://localhost:6379')
      self.redis_sentinels = hash.fetch(:redis_sentinels, nil)
      self.gushfile        = hash.fetch(:gushfile, 'Gushfile')
    end

    def gushfile=(path)
      @gushfile = Pathname(path)
    end

    def gushfile
      @gushfile.realpath if @gushfile.exist?
    end

    def to_hash
      {
        concurrency:     concurrency,
        namespace:       namespace,
        redis_url:       redis_url,
        redis_sentinels: redis_sentinels
      }
    end

    def to_json
      Gush::JSON.encode(to_hash)
    end
  end
end
