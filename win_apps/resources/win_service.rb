# actions :install, :start
# default_action :install

# attribute :service_name, :name_attribute => true, :kind_of => String, :required => true
# attribute :service_source, :kind_of => String, :required => true
# attribute :service_executable_with_args, :kind_of => String, :required => true
# attribute :service_install_base_path, :kind_of => String, :default => "#{ENV['SYSTEMDRIVE']}\\winservices"
# attribute :service_start, :kind_of => Symbol, :equal_to => [:automatic, :disabled, :manual],  :default => :manual
# attribute :scm, :kind_of => Hash, :required => true
# attribute :new_app_config, :kind_of => String
# attribute :should_replace_app_config, :kind_of => [TrueClass, FalseClass], :default => false
# attribute :app_erb_config, :kind_of => String
# attribute :app_config_params, :kind_of => Hash