#
# Cookbook Name:: clarifi_apps
# Recipe:: teaser_website
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug


apps = search(:aws_opsworks_app, "deploy:true") rescue []
app = apps.find {|x| x[:shortname] == "teaser_website"}
if app
	Chef::Log.debug "Found #{app[:shortname]} to deploy on the stack. Assuming teaser_website app is same."

	win_apps_website node['teaser_website']['site_name'] do
	  host_header node['teaser_website']['host_header']
	  port node['teaser_website']['port']
	  protocol node['teaser_website']['protocol']
	  website_base_directory node['teaser_website']['site_base_directory']
	  runtime_version node['teaser_website']['runtime_version']
	  scm app["app_source"]
	  should_replace_web_config node['teaser_website']["should_replace_web_config"]
	  new_web_config node['teaser_website']["new_web_config"]
	  web_erb_config node['teaser_website']["web_config_erb"]
	  web_config_params node['teaser_website']["web_config_params"]
	  action :add
	end
else
	Chef::Log.debug "teaser_website app not found in apps to deploy."
end
