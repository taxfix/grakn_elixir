ExUnit.start()

exit = fn message ->
    IO.puts(message)
    System.halt(1)
end

engine_status = fn output ->
    output 
    |> String.split("\n")
    |> Enum.at(-2)
    |> String.split(":")
    |> Enum.at(1)
    |> String.trim
end

{output, status} = System.cmd("grakn", ["server", "status"])
cond do
    status != 0 -> exit.("Unable to execute 'grakn' command. Make sure Grakn is installed")
    engine_status.(output) === "RUNNING" -> :running
    true -> System.cmd("grakn", ["server", "start"])
end