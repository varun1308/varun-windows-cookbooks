#tmc website attributes
default['tmc_website']['site_name'] = 'tmc_website'
default['tmc_website']['host_header'] = ''
default['tmc_website']['port'] = 80
default['tmc_website']['protocol'] = :http
default['tmc_website']['runtime_version'] = '4.0'
default['tmc_website']['site_base_directory'] = "#{ENV['SYSTEMDRIVE']}\\inetpub\\wwwroot"
default['tmc_website']["should_replace_web_config"] = false
default['tmc_website']["new_web_config"] = nil
default['tmc_website']["web_config_erb"] = nil
default['tmc_website']["web_config_params"] = Hash.new

#teaser website attributes
default['teaser_website']['site_name'] = 'teaser_website'
default['teaser_website']['host_header'] = 'teaser.clarifi.io'
default['teaser_website']['port'] = 80
default['teaser_website']['protocol'] = :http
default['teaser_website']['runtime_version'] = '4.0'
default['teaser_website']['site_base_directory'] = "#{ENV['SYSTEMDRIVE']}\\inetpub\\wwwroot"
default['teaser_website']["should_replace_web_config"] = false
default['teaser_website']["new_web_config"] = nil
default['teaser_website']["web_config_erb"] = nil
default['teaser_website']["web_config_params"] = Hash.new

