# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
  
  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit
  
  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user

  def self.random_code
    short_url = SecureRandom.urlsafe_base64
    while ShortenedUrl.find_by(short_url: short_url)
      short_url = SecureRandom.urlsafe_base64
    end
    short_url
  end

  def self.create!(user, long_url)
    user = ShortenedUrl.new(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
    user.save!
  end

  def num_clicks
    self.visits.size
  end

  def num_uniques
    visitors.count
    # Visit.where("shortened_url_id = #{self.id}").select(:user_id).distinct.count
  end

  def num_recent_uniques
    ten_minutes_ago = 10.minutes.ago
    Visit.where({shortened_url_id: self.id, created_at: (Time.now - 10.minutes)..Time.now }).select(:user_id).distinct.count
  end
end
