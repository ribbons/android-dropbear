# frozen_string_literal: true

# Copyright © 2021 Matt Robinson

module Overcommit
  module Hook
    module PreCommit
      class SingleNewlineAtEof < Base
        def run
          messages = []

          applicable_files.each do |file|
            content = File.read(file)
            next if content.empty?

            relfile = file.delete_prefix("#{Overcommit::Utils.repo_root}/")

            begin
              if content =~ /\R\R\z/
                messages << Overcommit::Hook::Message.new(
                  :error,
                  file,
                  nil,
                  "#{relfile}: Multiple newlines at end of file"
                )
              elsif !content.end_with?("\n")
                messages << Overcommit::Hook::Message.new(
                  :error,
                  file,
                  nil,
                  "#{relfile}: No newline at end of file"
                )
              end
            rescue ArgumentError
              # Not valid UTF-8, probably a binary file
              next
            end
          end

          messages
        end
      end
    end
  end
end
