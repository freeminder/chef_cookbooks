node.default['app']['app_path'] = '/srv/www/sliderapp'
node.default['app']['app_dc_path'] = '/srv/www/digital-candy'
node.default['app']['passenger_root'] = '/usr/local/rvm/gems/ruby-2.1.2/gems/passenger-4.0.45'
node.default['app']['passenger_ruby'] = '/usr/local/rvm/gems/ruby-2.1.2/wrappers/ruby'
node.default['app']['rails_public_root'] = '/srv/www/sliderapp/current/public'

# MAPPING: WHICH VHOST GOES TO WHICH GROUP
node.default['app']['vhosts'] = {
  'dev.swapslider.com' => [
    'dev.swapslider.com'
  ],
  # 'site2' => [
  #   'secondsite.com',
  #   'www.secondsite.com',
  # ],
}
