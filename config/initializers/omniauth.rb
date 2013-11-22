Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['1479578555600942'], ENV['fc183993624d812466f13a571bf3df0c'], :scope => 'user_likes, user_location', :display => 'popup'
end