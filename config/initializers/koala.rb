case Rails.env
when 'development', 'test'
  url_for_callback = 'http://localhost:3000/users/create'
when 'production'
  url_for_callback = 'http://162.243.246.245/users/create'
end

FacebookOAuth = Koala::Facebook::OAuth.new('320530461418360', 'd555fdb9767c092d4d1179ba8924a0fa', url_for_callback)

