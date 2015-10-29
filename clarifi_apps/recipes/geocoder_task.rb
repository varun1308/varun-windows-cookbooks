#
# Cookbook Name:: clarifi_apps
# Recipe:: geocoder_task
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

Chef::Log.level = :debug

apps = search(:aws_opsworks_app, "deploy:true") rescue []
app = apps.find {|x| x[:shortname] == "geocoder_task"}

if app
	Chef::Log.debug "Found #{app[:shortname]} to deploy on the stack. Assuming geocoder_task app is same."

	win_apps_win_task node['geocoder_task']['task_name'] do
		command node['geocoder_task']['task_executable_with_args']
		scm app["app_source"]
		task_install_base_path node['geocoder_task']['task_install_base_path']
		new_app_config node['geocoder_task']['new_app_config']
		should_replace_app_config node['geocoder_task']['should_replace_app_config'] 
		app_erb_config node['geocoder_task']['app_erb_config']
		app_config_params node['geocoder_task']['app_config_params']
		force node['geocoder_task']['force']
		run_level node['geocoder_task']['run_level']
		frequency node['geocoder_task']['frequency']
		frequency_modifier node['geocoder_task']['frequency_modifier']
		start_day node['geocoder_task']['start_day']
		start_time node['geocoder_task']['start_time']
		interactive_enabled node['geocoder_task']['interactive_enabled']
		day node['geocoder_task']['day']
		action :create, :enable
	end
else
	Chef::Log.debug "geocoder_task app not found in apps to deploy."
end