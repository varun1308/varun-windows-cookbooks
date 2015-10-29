#
# Cookbook Name:: clarifi_apps
# Recipe:: tmc_website
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug

apps = search(:aws_opsworks_app, "deploy:true") rescue []
app = apps.find {|x| x[:shortname] == "tmc_website"}
if app
	Chef::Log.debug "Found #{app[:shortname]} to deploy on the stack. Assuming tmc_website app is same."

	win_apps_website node['tmc_website']['site_name'] do
	  host_header node['tmc_website']['host_header']
	  port node['tmc_website']['port']
	  protocol node['tmc_website']['protocol']
	  website_base_directory node['tmc_website']['site_base_directory']
	  runtime_version node['tmc_website']['runtime_version']
	  scm app["app_source"]
	  should_replace_web_config false
	  #web_erb_config 'Web.config.erb'
	  #web_config_params node['tmc_website']["web_config_params"]
	  action :add
	end
else
	Chef::Log.debug "tmc_website app not found in apps to deploy."
end
