defmodule Base58Check.Mixfile do
  use Mix.Project

  def project do
    [app: :base58check,
     version: "0.1.0",
     elixir: "~> 1.0",
     deps: deps(),
     package: package(),
     name: "Base58Check",
     source_url: "https://github.com/lukaszsamson/base58check",
     homepage_url: "https://github.com/lukaszsamson/base58check",
     description: """
     Elixir implementation of Base58Check encoding meant for Bitcoin
     """]
  end

  def application do
    [applications: [:logger, :crypto]]
  end

  defp package do
    [contributors: ["Gabriel Jaldon", "Łukasz Samson"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/lukaszsamson/base58check"}]
  end

  defp deps do
    []
  end
end
