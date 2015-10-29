#
# Cookbook Name:: clarifi_apps
# Recipe:: roomstd_website
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug


apps = search(:aws_opsworks_app, "deploy:true") rescue []
app = apps.find {|x| x[:shortname] == "roomstd_website"}
if app
	Chef::Log.debug "Found #{app[:shortname]} to deploy on the stack. Assuming roomstd_website app is same."

	win_apps_website node['roomstd_website']['site_name'] do
	  host_header node['roomstd_website']['host_header']
	  port node['roomstd_website']['port']
	  protocol node['roomstd_website']['protocol']
	  website_base_directory node['roomstd_website']['site_base_directory']
	  runtime_version node['roomstd_website']['runtime_version']
	  scm app["app_source"]
	  should_replace_web_config node['roomstd_website']["should_replace_web_config"]
	  new_web_config node['roomstd_website']["new_web_config"]
	  web_erb_config node['roomstd_website']["web_config_erb"]
	  web_config_params node['roomstd_website']["web_config_params"]
	  action :add
	end
else
	Chef::Log.debug "roomstd_website app not found in apps to deploy."
end
