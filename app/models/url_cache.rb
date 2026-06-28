class UrlCache < ApplicationRecord
  has_many :posts, dependent: :nullify

  # has_one_attached :thumb do |attachable|
  #   attachable.variant :square_350, resize_to_fit: [ 350, 350 ], saver: { quality: 80 }, preprocessed: true
  # end

  # validates :thumb, content_type: { in: [ :png, :jpeg, :gif ], spoofing_protection: true }

  def fresh?
    refreshed_at.present? && refreshed_at > 1.hour.ago
  end
end
