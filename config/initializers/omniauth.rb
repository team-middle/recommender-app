Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '1479578555600942', 'fc183993624d812466f13a571bf3df0c', :scope => 'user_likes, user_location'
end