defmodule Thesaurusizer.Bot do
  use ExGram.Bot, name: Application.get_env(:thesaurusizer, :bot_name)

  command("start")

  def handle({:command, :start, %{}}, cnt) do
    reply(cnt, "Welcome! Send me any text and I will thesaurusize it.")
  end

  def handle({:text, text, %{}}, cnt) when is_binary(text) do
    reply(cnt, Thesaurusizer.thesaurusize(text))
  end

  def handle(_, _) do
    nil
  end

  defp reply(cnt = %{update: %{message: %{message_id: message_id}}}, message) do
    answer(cnt, message, reply_to_message_id: message_id)
  end
end
