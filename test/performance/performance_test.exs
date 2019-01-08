defmodule PerformanceTest do
  use Grakn.Graql

  parallel =
    System.argv()
    |> case do
      [param] -> param |> String.to_integer()
      [] -> 1
    end

  Benchee.run(
    %{
      "create_schema" => fn ->
        {:ok, pid} = Grakn.start_link(hostname: "127.0.0.1")

        schema = [
          define(:attr_a, sub: :attribute, datatype: datatypes().string),
          define(:attr_b, sub: :attribute, datatype: datatypes().long),
          define(:attr_c, sub: :attribute, datatype: datatypes().boolean),
          define(:has_dependant,
            sub: :relationship,
            relates: [:supporter, :dependant]
          ),
          define(:employs,
            sub: :relationship,
            relates: [:employer, :employee]
          ),
          define(:a,
            sub: :entity,
            has: [:attr_a, :attr_b, :attr_c],
            plays: [:supporter, :employer, :employee]
          ),
          define(:b, sub: :a, plays: [:dependant, :employee])
        ]

        {:ok, _} =
          Grakn.transaction(
            pid,
            fn conn ->
              for definition <- schema do
                Grakn.query!(conn, definition)
              end
            end,
            keyspace: "s_#{:rand.uniform(1000)}_#{System.system_time()}",
            type: Grakn.Transaction.Type.write()
          )
      end
    },
    parallel: parallel
  )
end
