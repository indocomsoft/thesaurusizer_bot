defmodule Thesaurusizer do
  @moduledoc """
  Documentation for Thesaurusizer.
  """

  # Top 15 words in Oxford English Corpus
  @stop_words ~w(the be to of and a in that have I it for not on with)

  def thesaurusize(passage, delimiter \\ " ")
      when is_binary(passage) and is_binary(delimiter) and byte_size(delimiter) == 1 do
    passage
    |> String.split(delimiter)
    |> Enum.map(fn word ->
      Task.async(fn ->
        sanitised_word = String.replace(word, ~r/[\p{P}\p{S}]/, "")

        if sanitised_word in @stop_words do
          word
        else
          {:ok, synonyms} = Thesaurusizer.API.get_synonyms(sanitised_word)

          synonyms
          |> Enum.filter(&(not String.contains?(&1, " ")))
          |> case do
            [] ->
              word

            one_word_synonyms ->
              one_word_synonyms
              |> Enum.random()
              |> (&String.replace(word, sanitised_word, &1)).()
          end
        end
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.join(delimiter)
  end
end
