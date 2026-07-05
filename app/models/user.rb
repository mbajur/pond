class User < ApplicationRecord
  has_many :sessions, dependent: :destroy
  has_many :collections, dependent: :destroy
  has_many :auth_codes, dependent: :destroy

  has_many :follows_as_actor, class_name: "Follow", foreign_key: :actor_id, dependent: :destroy
  has_many :follows_as_target, -> { where(target_type: "User") }, class_name: "Follow", foreign_key: :target_id, dependent: :destroy
  has_many :followers, through: :follows_as_target, source: :actor
  has_many :following_users, through: :follows_as_actor, source: :target, source_type: "User"
  has_many :following_collections, through: :follows_as_actor, source: :target, source_type: "Collection"

  after_create :create_inbox_collection

  def self.find_by_username!(username)
    find_by!(username: username.gsub("@", ""))
  end

  def to_param
    "@#{username}"
  end

  def to_s
    "@#{username}"
  end

  def following?(target)
    Follow.where(actor: self, target: target).exists?
  end

  def premium?
    premium_until.present? && premium_until > Time.current
  end

  private

  # @todo move that out of here
  def create_inbox_collection
    collections.create!(inbox: true, name: "Inbox", private: true)
  end
end
