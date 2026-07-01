module AuthCode::Code
  CODE_SUBSTITUTIONS = { "O" => "0", "I" => "1", "L" => "1" }.freeze
  BASE32_ALPHABET = ("0".."9").to_a + ("A".."Z").to_a - [ "I", "L", "O", "U" ]

  class << self
    # At the time of implementation, PPP is not on rails master and base32 method is not available.
    # Once it is, we can switch to that and remove the custom logic.
    def generate(length)
      # SecureRandom.base32(length)
      SecureRandom.alphanumeric(length, chars: BASE32_ALPHABET)
    end

    def sanitize(code)
      if code.present?
        normalize_code(code)
          .then { apply_substitutions(it) }
          .then { remove_invalid_characters(it) }
      end
    end

    private

    def normalize_code(code)
      code.to_s.upcase
    end

    def apply_substitutions(code)
      CODE_SUBSTITUTIONS.reduce(code) { |result, (from, to)| result.gsub(from, to) }
    end

    def remove_invalid_characters(code)
      code.gsub(/[^#{SecureRandom::BASE32_ALPHABET.join}]/, "")
    end
  end
end
