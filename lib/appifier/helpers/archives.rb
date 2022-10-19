# frozen_string_literal: true

require 'rubygems/package'
require 'zlib'
require 'open-uri'

module Appifier
  module Helpers
    module Archives
      def untar_gz(archive:, destination:)
        source = open archive
        ::Gem::Package::TarReader.new(Zlib::GzipReader.new(source)) do |tar|
          dest = nil
          tar.each do |entry|
            if entry.full_name == '././@LongLink'
              dest = File.join destination, entry.read.strip
              next
            end
            dest ||= File.join destination, entry.full_name
            if entry.directory?
              File.delete dest if File.file? dest
              FileUtils.mkdir_p dest, mode: entry.header.mode, verbose: false
            elsif entry.file?
              FileUtils.rm_rf dest if File.directory? dest
              File.open dest, 'wb' do |f|
                f.print entry.read
              end
              FileUtils.chmod entry.header.mode, dest, verbose: false
            elsif entry.header.typeflag == '2' # Symlink!
              File.symlink entry.header.linkname, dest
            end
            dest = nil
          end
        end
      end
    end
  end
end
