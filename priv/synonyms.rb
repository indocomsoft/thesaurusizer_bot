#!/usr/bin/env ruby
require 'rwordnet'
require 'json'
puts WordNet::Lemma.find_all(ARGV.first)
                   .flat_map(&:synsets)
                   .flat_map(&:words)
                   .map { |word| word.gsub(/\(.*\)/, '') }
                   .uniq
                   .filter { |word| !ARGV.first.include?(word) && !word.include?(ARGV.first) }
                   .filter { |word| !word.include?('_') }
                   .to_json
