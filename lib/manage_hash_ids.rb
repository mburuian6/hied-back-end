module ManageHashIds
  class << self
    def encode(obj_id, min_hash_length: 10)
      generate_hash(min_hash_length: min_hash_length).encode(obj_id.to_s)
    end

    def decode(str, min_hash_length)
      generate_hash(min_hash_length: min_hash_length).decode(str).first
    end

    def encode_bid(obj_id, min_hash_length: 15)
      generate_hash(min_hash_length: min_hash_length).encode(obj_id.to_s)
    end

    def decode_bid(str, min_hash_length)
      generate_hash(min_hash_length: min_hash_length).decode(str).first
    end

    def generate_hash(min_hash_length: 10)
      alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
      Hashids.new(Rails.application.secret_key_base, min_hash_length, alphabet)
    end
  end
end