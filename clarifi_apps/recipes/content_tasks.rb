#
# Cookbook Name:: clarifi_apps
# Recipe:: content_tasks
#
# Copyright (c) 2015 The Authors, All Rights Reserved.


Chef::Log.level = :debug

apps = search(:aws_opsworks_app, "deploy:true") rescue []
app = apps.find {|x| x[:shortname] == "content_tasks"}

if app
	Chef::Log.debug "Found #{app[:shortname]} to deploy on the stack. Assuming content_tasks app is same."

	win_apps_win_service node['content_tasks']['service_name'] do
		service_source node['content_tasks']['service_source']
		service_executable_with_args node['content_tasks']['service_executable_with_args']
		service_start node['content_tasks']['service_start']
		scm app["app_source"]
		service_install_base_path node['content_tasks']['service_install_base_path']
		new_app_config node['content_tasks']['new_app_config']
		should_replace_app_config node['content_tasks']['should_replace_app_config'] 
		app_erb_config node['content_tasks']['app_erb_config']
		app_config_params node['content_tasks']['app_config_params']
		action :install		#action [:install, :start]
	end
else
	Chef::Log.debug "content_tasks app not found in apps to deploy."
end