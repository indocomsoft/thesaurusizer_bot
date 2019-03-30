#!/usr/bin/env ruby
require 'rwordnet'
require 'json'

STOP_WORDS = %w[the be to of and a in that have I it for not on with].freeze

def get_synonyms(word)
  WordNet::Lemma.find_all(word)
                .flat_map(&:synsets)
                .flat_map(&:words)
                .map { |syn| syn.gsub(/\(.*\)/, '') }
                .uniq
                .select { |syn| !word.include?(syn) && !syn.include?(word) }
                .reject { |syn| syn.include?('_') }
end

def process_word(word)
  sanitised_word = word.gsub(/[\p{P}\p{S}]/, '')

  if STOP_WORDS.include?(sanitised_word)
    word
  else
    synonyms = get_synonyms(word)

    if synonyms.empty?
      word
    else
      syn = synonyms.sample
      word.gsub(sanitised_word, syn)
    end
  end
end

passage, delimiter = ARGV

puts passage.split(delimiter)
            .map { |word| process_word(word) }
            .join(delimiter)
