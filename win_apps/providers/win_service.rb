def whyrun_supported?
  true
end

use_inline_resources

action :install do

	service_directory = "#{new_resource.service_install_base_path}\\#{new_resource.service_name}"

	app_checkout = Chef::Config["file_cache_path"] + "\\#{new_resource.service_name}"
	
	#stop the service
	windows_service "#{new_resource.service_name}" do
	  action :stop
	  ignore_failure true
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
			unless new_resource.app_erb_config.empty? 
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
		if Dir.exist?(service_directory)
			#delete existing directory
			directory service_directory do
				action :delete
			end
		end
		
		#move extracted files to service directory
		# Copy app to deployment directory
		execute "copy #{new_resource.service_name}" do
			command "Robocopy.exe #{app_checkout} #{service_directory} /MIR /XF .gitignore /XF app.config.erb /XD .git"
			returns [0, 1, 3]
		end

		powershell_script 'delete_if_exist' do
		  code <<-EOH
		     $Service = Get-WmiObject -Class Win32_Service -Filter "Name='#{new_resource.service_name}'"
		     if ($Service) {
		        $Service.Delete() 
		     }
		  EOH
		  notifies :run, "execute[Installing Service #{new_resource.service_name}]", :immediately
		end

		execute "Installing Service #{new_resource.service_name}" do
		  command "sc create \"#{new_resource.service_name}\" binPath= \"#{service_directory}\\#{new_resource.service_executable_with_args}\""
		  action :nothing
		end

		#configure startup
		windows_service "#{new_resource.service_name}" do
		  action :configure_startup
		  startup_type new_resource.service_start
		end
	end
end

action :start do

	#start the service
	windows_service "#{new_resource.service_name}" do
	  action :start
	end
end