json.array!(@courses) do |course|
  json.extract! course, :id, :title, :description, :category, :image_url
  json.url course_url(course, format: :json)
end
