# frozen_string_literal: true

module Appifier
  module Helpers
    module User
      # return the 'root' name
      # @return [String] name
      def user_root
        Etc.getpwuid(0).name
      end

      # return the current user name
      # @return [String] name
      def current_user
        Etc.getpwuid(Process.uid).name
      end

      # return the 'root' group name : root or wheel
      # @return [String] name
      def group_root
        Etc.getgrgid(0).name
      end

      # facility to verifying if the active process run as root
      # @return [Bool] status
      def is_root?
        case Process.uid
        when 0
          true
        else
          false
        end
      end
    end
  end
end
