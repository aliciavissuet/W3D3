# == Schema Information
#
# Table name: visits
#
#  id               :bigint(8)        not null, primary key
#  shortened_url_id :integer          not null
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :shortened_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :ShortenedUrl

  def self.record_visit!(shortened_url, user)
    visit = Visit.new(shortened_url_id: shortened_url.id, user_id: user.id)
    visit.save!
  end

  
end
