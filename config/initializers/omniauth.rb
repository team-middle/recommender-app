Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '320530461418360', 'd555fdb9767c092d4d1179ba8924a0fa', :scope => 'user_likes, user_location'
end
