# Grakn Elixir Performance Test

## Run

1. Instal Elixir (https://elixir-lang.org/install.html)
   ```
   brew install elixir
   ```
2. From this the root of this repo run the following command:
   ```
   mix run test/performance/performance_test.exs
   ```
   If you want to run parallel queries to Elixir pass the a concurrency number as argument
   ```
   mix run test/performance/performance_test.exs 4
   ```
