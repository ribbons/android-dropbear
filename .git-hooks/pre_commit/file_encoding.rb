# frozen_string_literal: true

# Copyright © 2021 Matt Robinson

module Overcommit
  module Hook
    module PreCommit
      class FileEncoding < Base
        def run
          messages = []

          applicable_files.each do |file|
            content = File.read(file)

            # Definitely not a text file if it contains null bytes
            next if content.b.include?("\x00")

            relfile = file.delete_prefix("#{Overcommit::Utils.repo_root}/")

            if !content.valid_encoding?
              messages << Overcommit::Hook::Message.new(
                :error,
                file,
                nil,
                "#{relfile}: Not encoded as UTF-8"
              )
            elsif content.start_with?("\uFEFF")
              messages << Overcommit::Hook::Message.new(
                :error,
                file,
                nil,
                "#{relfile}: Starts with a UTF-8 BoM"
              )
            end
          end

          messages
        end
      end
    end
  end
end
