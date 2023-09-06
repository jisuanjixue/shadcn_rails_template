# == Schema Information
# Schema version: 20230906035959
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  comments_count :integer
#  description    :text
#  slug           :string
#  status         :integer
#  title          :string
#  views          :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_slug     (slug) UNIQUE
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Post < ApplicationRecord
  extend FriendlyId
  validates :title, presence: true
  belongs_to :user
  has_rich_text :description
  enum :status, { draft: 0, underway: 1, done: 2, archived: 3 }
  has_many_attached :images
  has_many :comments, dependent: :destroy

  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user

  friendly_id :title, use: %i[slugged history finders]

  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end
end
