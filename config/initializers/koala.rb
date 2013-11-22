case Rails.env
when 'development', 'test'
  url_for_callback = 'http://localhost:3000/users/create'
when 'production'
  raise 'Configure Facebook Oauth'
end

FacebookOAuth = Koala::Facebook::OAuth.new('1479578555600942', 'fc183993624d812466f13a571bf3df0c', url_for_callback)