defmodule Thesaurusizer.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      ExGram,
      {Thesaurusizer.Bot, [method: :polling, token: token]}
    ]

    opts = [strategy: :one_for_one, name: Thesaurusizer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
