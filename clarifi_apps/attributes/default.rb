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

#roomstd website attributes
default['roomstd_website']['site_name'] = 'roomstd_website'
default['roomstd_website']['host_header'] = 'roomstd.clarifi.io'
default['roomstd_website']['port'] = 80
default['roomstd_website']['protocol'] = :http
default['roomstd_website']['runtime_version'] = '4.0'
default['roomstd_website']['site_base_directory'] = "#{ENV['SYSTEMDRIVE']}\\inetpub\\wwwroot"
default['roomstd_website']["should_replace_web_config"] = false
default['roomstd_website']["new_web_config"] = nil
default['roomstd_website']["web_config_erb"] = nil
default['roomstd_website']["web_config_params"] = Hash.new

#content_tasks windows service attributes
default['content_tasks']['service_name'] = 'ContentManagementService'
default['content_tasks']['service_source'] = nil
default['content_tasks']['service_executable_with_args'] = 'Clarifi.ContentManagement.WinService.exe ,1,2,3,4,5,6,7,8,9,D,E,F,G,H,I,J,K,L,M'
default['content_tasks']['service_start'] = :manual
default['content_tasks']['service_install_base_path'] = "#{ENV['SYSTEMDRIVE']}\\winservices"
default['content_tasks']['new_app_config'] = nil
default['content_tasks']['should_replace_app_config'] = false
default['content_tasks']['app_erb_config'] = nil
default['content_tasks']['app_config_params'] = Hash.new
