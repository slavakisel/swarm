class Link < ApplicationRecord
  validates :url, presence: true, length: { maximum: 2083 }

  paginates_per 25
  max_paginates_per 50

  scope :processed, -> { where.not(last_processed_at: nil) }

  def processed?
    !!last_processed_at
  end

  def modified?
    last_modified_at && last_modified_at > last_processed_at
  end
end
