defmodule Thesaurusizer do
  @moduledoc """
  Documentation for Thesaurusizer.
  """

  @stop_words ~w(the be to of and a in that have I it for not on with)

  def thesaurusize(passage, delimiter \\ " ")
      when is_binary(passage) and is_binary(delimiter) and byte_size(delimiter) == 1 do
    passage
    |> String.split(delimiter)
    |> Enum.map(&process_word/1)
    |> Enum.join(delimiter)
  end

  defp process_word(word) when is_binary(word) do
    IO.inspect(word)
    sanitised_word = String.replace(word, ~r/[\p{P}\p{S}]/, "")
    folded_word = String.downcase(sanitised_word)

    if folded_word in @stop_words do
      word
    else
      case get_synonyms(folded_word) do
        [] ->
          word

        synonyms ->
          new_word = Enum.random(synonyms)

          new_word =
            cond do
              Regex.match?(~r/^\p{Lu}.*/, word) ->
                String.capitalize(new_word)

              Regex.match?(~r/^\p(Lu)*$/, word) ->
                String.upcase(new_word)

              true ->
                new_word
            end

          String.replace(word, sanitised_word, new_word)
      end
    end
  end

  defp get_synonyms(word) when is_binary(word) do
    ExWordNet.Lemma.find_all(word)
    |> Enum.flat_map(&ExWordNet.Lemma.synsets/1)
    |> Enum.flat_map(&ExWordNet.Synset.words/1)
    |> Enum.map(&String.replace(&1, ~r/\(.*\)/, ""))
    |> Enum.uniq()
    |> Enum.filter(fn syn ->
      not String.contains?(word, syn) and not String.contains?(syn, word)
    end)
    |> Enum.reject(&String.contains?(&1, "_"))
  end
end
