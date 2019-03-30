defmodule Thesaurusizer.API do
  @api_base_url "https://thesaurus.altervista.org"
  @api_base_path "/thesaurus/v1"
  @api_url "#{@api_base_url}#{@api_base_path}"

  def get_synonyms(word, language \\ "en_US") when is_binary(word) and is_binary(language) do
    query = URI.encode_query(%{word: word, language: language, output: "json", key: api_key()})

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           HTTPoison.get("#{@api_url}?#{query}"),
         {:ok, %{"response" => response}} <- Jason.decode(body) do
      answer =
        response
        |> Enum.map(fn %{"list" => %{"synonyms" => synonyms}} -> synonyms end)
        |> Enum.flat_map(&String.split(&1, "|"))
        |> Enum.map(&String.replace(&1, ~r/ \(.*\)/, ""))

      {:ok, answer}
    else
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:ok, [word]}
      {:error, reason} -> {:error, reason}
    end
  end

  defp api_key, do: Application.get_env(:thesaurusizer, :api_key)
end
