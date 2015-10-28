#
# Author:: Kartik Cating-Subramanian (<ksubramanian@chef.io>)
#
# Copyright 2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'spec_helper'

describe 'iis::default' do
  # We are expecting to run these tests against recent versions of Windows
  # as that's what's in our test matrix (Windows 2008r2 and above).
  # This let's us avoid re-implementing all the cookbook logic to MUX the
  # various package names for back-compat.

  describe windows_feature('IIS-WebServerRole') do
    it { should be_installed }
  end

  describe service('World Wide Web Publishing Service') do
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end

  # Unless we are on a 'polluted' machine, the default website should
  # be present if the IIS Role was freshly installed.  All our vagrant
  # configurations install with the system drive at C:\
  describe iis_website('Default Web Site') do
    it { should exist }
    it { should be_enabled }
    it { should be_running }
    it { should be_in_app_pool('DefaultAppPool') }
  end
end
