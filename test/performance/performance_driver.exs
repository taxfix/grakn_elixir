defmodule PerformanceTestDriver do
  use Grakn.Graql

  def run() do
    parallel =
      case System.argv() do
        [param] -> String.to_integer(param)
        [] -> div(:erlang.system_info(:schedulers), 2)
      end

    Grakn.start_link(hostname: "127.0.0.1", name: Grakn)

    Benchee.run(
      %{
        "create_schema" => &create_schema_test/0,
        "insert" => &insert_test/0,
        "multi_transaction" => &multi_transaction_test/0
      },
      parallel: parallel,
      time: 30
    )
  end

  defp create_schema_test() do
    {:ok, _} = Grakn.transaction(Grakn, &create_schema/1, gen_transaction_opts())
  end

  @schema [
    define(:attr_a, sub: :attribute, datatype: datatypes().string),
    define(:attr_b, sub: :attribute, datatype: datatypes().long),
    define(:attr_c, sub: :attribute, datatype: datatypes().boolean),
    define(:has_dependant,
      sub: :relation,
      relates: [:supporter, :dependant]
    ),
    define(:employs,
      sub: :relation,
      relates: [:employer, :employee]
    ),
    define(:a,
      sub: :entity,
      has: [:attr_a, :attr_b, :attr_c],
      plays: [:supporter, :employer, :employee]
    ),
    define(:b, sub: :a, plays: [:dependant, :employee])
  ]

  defp create_schema(conn) do
    for definition <- @schema, do: Grakn.query!(conn, definition)
  end

  defp insert_test() do
    {:ok, _} = Grakn.transaction(Grakn, &insert/1, gen_transaction_opts())
  end

  defp insert(conn) do
    create_basic_schema(conn)
    for i <- 1..50, do: do_insert(conn, i)
  end

  @schema [
    define(:attr_a, sub: :attribute, datatype: datatypes().long),
    define(:a,
      sub: :entity,
      has: [:attr_a]
    )
  ]

  defp create_basic_schema(conn) do
    for definition <- @schema, do: Grakn.query!(conn, definition)
  end

  defp do_insert(conn, i) do
    Grakn.query!(conn, Grakn.Query.graql("insert $x isa a, has attr_a #{i};"))
  end

  defp multi_transaction_test() do
    opts = gen_transaction_opts()
    {:ok, _} = Grakn.transaction(Grakn, &create_basic_schema/1, opts)

    for i <- 1..50 do
      {:ok, _} = Grakn.transaction(Grakn, &do_insert(&1, i), opts)
    end
  end

  defp gen_transaction_opts() do
    [
      keyspace: "s_#{:rand.uniform(1000)}_#{System.system_time()}",
      type: Grakn.Transaction.Type.write()
    ]
  end
end

PerformanceTestDriver.run()
