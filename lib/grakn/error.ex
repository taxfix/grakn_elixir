defmodule Grakn.Error do
  defexception message: "Grakn error", reason: nil

  def exception(message, reason), do: %__MODULE__{message: message, reason: reason}
  def exception(message), do: %__MODULE__{message: message}
  def exception(), do: %__MODULE__{}
end
