require 'fileutils'

module Support
  module Tmp
    def setup_tmp_directory
      remove_tmp_directory
      FileUtils.mkdir 'tmp'
    end

    def remove_tmp_directory
      FileUtils.rm_rf 'tmp' if File.directory?('tmp')
    end
  end
end
