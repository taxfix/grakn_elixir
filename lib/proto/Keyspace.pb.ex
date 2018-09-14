defmodule Keyspace.Keyspace do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.Keyspace.Retrieve do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.Keyspace.Retrieve.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.Keyspace.Retrieve.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          names: [String.t()]
        }
  defstruct [:names]

  field(:names, 1, repeated: true, type: :string)
end

defmodule Keyspace.Keyspace.Create do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.Keyspace.Create.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t()
        }
  defstruct [:name]

  field(:name, 1, type: :string)
end

defmodule Keyspace.Keyspace.Create.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.Keyspace.Delete do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.Keyspace.Delete.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t()
        }
  defstruct [:name]

  field(:name, 1, type: :string)
end

defmodule Keyspace.Keyspace.Delete.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Keyspace.KeyspaceService.Service do
  @moduledoc false
  use GRPC.Service, name: "keyspace.KeyspaceService"

  rpc(:create, Keyspace.Keyspace.Create.Req, Keyspace.Keyspace.Create.Res)
  rpc(:retrieve, Keyspace.Keyspace.Retrieve.Req, Keyspace.Keyspace.Retrieve.Res)
  rpc(:delete, Keyspace.Keyspace.Delete.Req, Keyspace.Keyspace.Delete.Res)
end

defmodule Keyspace.KeyspaceService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Keyspace.KeyspaceService.Service
end
