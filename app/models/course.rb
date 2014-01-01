class Course
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  field :category, type: String
  field :image_url, type: String
end
