class Post < ApplicationRecord
  has_many :bids, dependent: :destroy
  has_many :rejected_bids, dependent: :destroy

  def mark_post_as_closed
    update(closed: true)
  end

end
