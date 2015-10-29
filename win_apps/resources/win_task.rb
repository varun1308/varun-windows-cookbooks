actions :create, :delete, :run, :end, :change, :enable, :disable
default_action :create

attribute :task_name, :name_attribute => true, :kind_of => String, :required => true
attribute :task_executable_with_args, :kind_of => String, :required => true
attribute :task_install_base_path, :kind_of => String, :default => "#{ENV['SYSTEMDRIVE']}\\wintasks"
attribute :task_start, :kind_of => Symbol, :equal_to => [:automatic, :disabled, :manual],  :default => :manual
attribute :scm, :kind_of => Hash, :required => true
attribute :new_app_config, :kind_of => String
attribute :should_replace_app_config, :kind_of => [TrueClass, FalseClass], :default => false
attribute :app_erb_config, :kind_of => String
attribute :app_config_params, :kind_of => Hash
# attribute :user, :kind_of => String, :default => 'SYSTEM'
# attribute :password, :kind_of => String, :default => nil
attribute :run_level, :equal_to => [:highest, :limited], :default => :limited
attribute :force, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :interactive_enabled, :kind_of => [ TrueClass, FalseClass ], :default => false
attribute :frequency_modifier, :kind_of => Integer, :default => 1
attribute :frequency, :equal_to => [:minute,
                                    :hourly,
                                    :daily,
                                    :weekly,
                                    :monthly,
                                    :once,
                                    :on_logon,
                                    :onstart,
                                    :on_idle], :default => :hourly
attribute :start_day, :kind_of => String, :default => nil
attribute :start_time, :kind_of => String, :default => nil
attribute :day, :kind_of => [ String, Integer ], :default => nil
