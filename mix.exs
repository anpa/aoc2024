defmodule AOC2024.MixProject do
  use Mix.Project

  def project do
    [
      app: :AOC2024,
      version: "1.0.0",
      elixir: "~> 1.17.3",
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp aliases do
    [
      lint: [
        "format",
        "credo --strict"
      ]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.7", only: [:dev], runtime: false}
    ]
  end
end
