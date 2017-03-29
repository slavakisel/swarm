class LinkSerializer < ActiveModel::Serializer
  attributes :id, :url

  has_many :elements
end
