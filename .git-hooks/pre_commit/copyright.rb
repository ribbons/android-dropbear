# frozen_string_literal: true

# Copyright © 2021 Matt Robinson

module Overcommit
  module Hook
    module PreCommit
      class Copyright < Base
        COPYRIGHT_REGEX = /© (?:[0-9]{4}-)?(?<year>[0-9]{4}) (?<aut>.+)/.freeze
        HASHBANG_REGEX = %r{^#! */(?:[a-z]+/)*[a-z0-9]+(?: |$)}.freeze
        NAMES_REGEX = /(?:^(?:CMakeLists[.]txt|Gemfile|Rakefile)|[.]
                          (?:bat|[ch]|cpp|cs|s?css|html|java|js|kt[ms]?|php|
                            p[lm]|rc|rb|sql|wxs))$/x.freeze

        def run
          messages = []
          outdated = @context.class.name != 'Overcommit::HookContext::RunAll'
          author_name = ENV['GIT_AUTHOR_NAME']

          applicable_files.each do |filename|
            relfile = filename.delete_prefix("#{Overcommit::Utils.repo_root}/")

            File.open(filename, 'r') do |file|
              found = false
              author_year = nil
              hashbang = false

              file.each_line do |line|
                if file.lineno == 1 && HASHBANG_REGEX.match(line)
                  hashbang = true
                end

                next unless (matches = COPYRIGHT_REGEX.match(line))

                found = true
                break unless outdated

                if matches[:aut].start_with?(author_name)
                  author_year = matches[:year].to_i
                end

                break if author_year == Time.now.year
              end

              if found
                if author_year != Time.now.year && outdated
                  messages << Overcommit::Hook::Message.new(
                    :error,
                    filename,
                    nil,
                    "#{relfile}: Copyright notice for #{author_name} " \
                    "#{author_year ? 'out of date' : 'missing'}"
                  )
                end

                next
              end

              if hashbang || NAMES_REGEX.match(File.basename(filename))
                messages << Overcommit::Hook::Message.new(
                  :error,
                  filename,
                  nil,
                  "#{relfile}: Copyright notice is missing"
                )
              end
            rescue ArgumentError
              # Not encoded as UTF-8 or a binary file
              next
            end
          end

          messages
        end
      end
    end
  end
end
