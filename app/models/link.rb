class Link < ApplicationRecord
  validates :url, presence: true, length: { maximum: 2083 }

  def processed?
    !!last_processed_at
  end

  def modified?
    last_modified_at && last_modified_at > last_processed_at
  end
end
