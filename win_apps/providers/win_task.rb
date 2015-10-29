def whyrun_supported?
  true
end

use_inline_resources

action :create do

	run_context.include_recipe 'aws'

	task_directory = "#{new_resource.task_install_base_path}\\#{new_resource.task_name}"

	app_checkout = Chef::Config["file_cache_path"] + "\\#{new_resource.task_name}"
	
	#disable the task
	windows_task "#{new_resource.task_name}" do
	  action :delete
	end

	Chef::Log.debug "Downloading app source file using info #{new_resource.scm}."

	#parse scm info
	if  new_resource.scm[:type].empty? || new_resource.scm[:type] != 's3'
		Chef::Log.error "Error: No s3 configuration found in scm parameter."
        raise Chef::Exceptions::UnsupportedAction "#{self.to_s} does not support repository types other than s3"

	else
		file_name, bucket, remote_path, url = Tavisca::WinApps::Helper.parse_uri(new_resource.scm[:url])

		#download file from s3
		aws_s3_file ::File.join(Chef::Config["file_cache_path"],file_name) do
		  bucket bucket
		  remote_path remote_path
		  aws_access_key_id new_resource.scm[:user]
		  aws_secret_access_key new_resource.scm[:password]
		end


		#unzip file to destination
		windows_zipfile app_checkout do
		  source ::File.join(Chef::Config["file_cache_path"],file_name)
		  action :unzip
		end

		#do app.config modifications
		if new_resource.should_replace_app_config
			Chef::Log.debug "Moving file #{new_resource.new_app_config}."
			powershell_script 'copy_app_config' do
			  code <<-EOH 
			     Copy-Item "#{app_checkout}\\#{new_resource.new_app_config}" "#{app_checkout}\\app.config" -Force
			  EOH
			end
		else
			unless new_resource.app_erb_config.nil? || new_resource.app_erb_config.empty? 
				Chef::Log.debug "app.config params #{new_resource.app_config_params}."

			 	template "#{app_checkout}\\app.config" do
			 	  local true
				  source "#{app_checkout}\\#{new_resource.app_erb_config}"
				  variables(
				  		:connection_strings => new_resource.app_config_params[:connection_strings]
				  )
				end
		 	
			else
				Chef::Log.debug "Did not find any app config replacement configuration."
			end
		end

		#move directory to destination
		if ::Dir.exist?(task_directory)
			#delete existing directory
			directory task_directory do
				recursive true
				action :delete
			end
		end
		
		#move extracted files to task directory
		# Copy app to deployment directory
		execute "copy #{new_resource.task_name}" do
			command "Robocopy.exe #{app_checkout} #{task_directory} /MIR /XF .gitignore /XF app.config.erb /XD .git"
			returns [0, 1, 3]
		end

		# powershell_script 'delete_if_exist' do
		#   code <<-EOH
		#      $task = Get-WmiObject -Class Win32_task -Filter "Name='#{new_resource.task_name}'"
		#      if ($task) {
		#         $task.Delete() 
		#      }
		#   EOH
		#   notifies :run, "execute[Installing task #{new_resource.task_name}]", :immediately
		# end

		windows_task new_resource.task_name do
		  cwd task_directory
		  force new_resource.force
		  command new_resource.task_executable_with_args
		  run_level new_resource.run_level
		  frequency new_resource.frequency
		  frequency_modifier new_resource.frequency_modifier
		  start_day new_resource.start_day
		  start_time new_resource.start_time
		  interactive_enabled new_resource.interactive_enabled
		  day new_resource.day
		  action :create
		end
	end
end

action :run do

	#start the task
	windows_task "#{new_resource.task_name}" do
	  action :run
	end
end

action :delete do

	#start the task
	windows_task "#{new_resource.task_name}" do
	  action :delete
	end
end

action :end do

	#start the task
	windows_task "#{new_resource.task_name}" do
	  action :end
	end
end

action :enable do

	#start the task
	windows_task "#{new_resource.task_name}" do
	  action :enable
	end
end

action :disable do

	#start the task
	windows_task "#{new_resource.task_name}" do
	  action :disable
	end
end