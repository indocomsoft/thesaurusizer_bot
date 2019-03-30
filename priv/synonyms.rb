#!/usr/bin/env ruby
require 'rwordnet'
require 'json'
puts WordNet::Lemma.find_all(ARGV.first)
                   .flat_map(&:synsets)
                   .flat_map(&:words)
                   .map { |word| word.gsub(/\(.*\)/, '') }
                   .uniq
                   .select { |word| !ARGV.first.include?(word) && !word.include?(ARGV.first) }
                   .reject { |word| word.include?('_') }
                   .to_json
