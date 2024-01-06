require "brotli"

class BrotliSerializer
  def self.dump(data)
    return nil if data.blank?

    "brotli" << Brotli.deflate(data)
  end

  def self.load(data)
    return nil if data.blank?
    return data unless data.start_with?("brotli")

    Brotli.inflate(data[6..])
  end
end
