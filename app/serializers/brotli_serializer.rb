require "brotli"

class BrotliSerializer
  def self.dump(data)
    data.present? ? Brotli.deflate(data) : nil
  end

  def self.load(data)
    data.present? ? Brotli.inflate(data).force_encoding("UTF-8") : nil
  end
end
