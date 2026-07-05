module Slugable
  extend ActiveSupport::Concern

  included do
    before_validation :generate_slug, if: :name_changed?

    def self.find_by_slug!(slug)
      find_by!(slug: slug)
    end
  end

  def to_param
    slug
  end

  private

  def generate_slug
    base_slug = name.to_s.parameterize
    self.slug = unique_slug(base_slug)
  end

  def unique_slug(base_slug)
    return base_slug unless self.class.exists?(slug: base_slug)

    loop do
      candidate = "#{base_slug}-#{random_suffix}"

      return candidate unless self.class.where.not(id: id).exists?(slug: candidate)
    end
  end

  def random_suffix
    SecureRandom.alphanumeric(6).downcase
  end
end
