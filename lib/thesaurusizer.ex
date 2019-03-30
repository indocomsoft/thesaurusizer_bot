defmodule Thesaurusizer do
  @moduledoc """
  Documentation for Thesaurusizer.
  """

  def thesaurusize(passage, delimiter \\ " ")
      when is_binary(passage) and is_binary(delimiter) and byte_size(delimiter) == 1 do
    case System.cmd("ruby", ["priv/synonyms.rb", passage, delimiter]) do
      {output, 0} ->
        output

      _ ->
        raise "Something goes wrong with the ruby script. Check ruby and the rwordnet gem is installed"
    end
  end
end
