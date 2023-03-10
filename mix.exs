defmodule PowRec.MixProject do
  use Mix.Project

  def project do
    [
      app: :powrec,
      version: "0.0.4",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:elixir_ale, "~> 1.2"},
      {:circuits_i2c, "~> 1.1"},
      {:ina219, "~> 2.0"}
    ]
  end
end
