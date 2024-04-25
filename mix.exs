defmodule DataframeTools.MixProject do
  use Mix.Project

  def project do
    [
      app: :dataframe_tools,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "Dataframe Tools",
      source_url: "https://github.com/nickkaltner/dataframe_tools"
    ]
  end

  defp description() do
    "Prototypes for some functions to assist with Explorer.Dataframe manipulation"
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
      {:explorer, "~> 0.8.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "dataframe_tools",
      # These are the default files included in the package
      # future: LICENSE*
      files: ~w(lib  .formatter.exs mix.exs README*
                ),
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/elixir-ecto/postgrex"}
    ]
  end
end
