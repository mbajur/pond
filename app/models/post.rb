class Post < ApplicationRecord
  include SearchCop
  include Fedipub::DataEntity

  has_many :pins, as: :pinable, dependent: :destroy
  has_many :collections, through: :pins
  belongs_to :collection, optional: true
  belongs_to :fedipub_actor, class_name: "Fedipub::Actor"
  has_one :user, through: :fedipub_actor, source: :entity, source_type: "User"

  search_scope :search do
    attributes user: "user.username"
    attributes :content, :title, :url
  end

  # We have to mve that here to be able to join it on searches. Not ideal but it works for now.
  has_one_attached :screenshot do |attachable|
    attachable.variant :square_350, resize_to_fit: [ 350, 350 ], format: :jpg, saver: { quality: 80 }, preprocessed: true
  end

  has_one_attached :thumb do |attachable|
    attachable.variant :square_350, resize_to_fit: [ 350, 350 ], saver: { quality: 80 }, preprocessed: true
  end

  validates :thumb, content_type: { in: [ :png, :jpeg, :gif, :webp ], spoofing_protection: true }

  after_commit :refresh_caches

  # @todo move that out of here
  def refresh_pins_cards
    pins.find_each do |pin|
      broadcast_replace_later_to(pin.collection, target: "pin_#{pin.id}", html: ApplicationController.render(Components::Pins::Pin.new(pin: pin), layout: false))
    end
  end

  def announcable?
    true
  end

  private

  # @todo probably move that to a job?
  def refresh_caches
    pins.touch_all
    collections.touch_all
  end
end
