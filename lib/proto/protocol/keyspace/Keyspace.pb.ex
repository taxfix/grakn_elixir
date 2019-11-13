defmodule Keyspace.Keyspace do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Keyspace.Keyspace.Retrieve do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Keyspace.Keyspace.Retrieve.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t(),
          password: String.t()
        }
  defstruct [:username, :password]

  field :username, 1, type: :string
  field :password, 2, type: :string
end

defmodule Keyspace.Keyspace.Retrieve.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          names: [String.t()]
        }
  defstruct [:names]

  field :names, 1, repeated: true, type: :string
end

defmodule Keyspace.Keyspace.Delete do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Keyspace.Keyspace.Delete.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          name: String.t(),
          username: String.t(),
          password: String.t()
        }
  defstruct [:name, :username, :password]

  field :name, 1, type: :string
  field :username, 2, type: :string
  field :password, 3, type: :string
end

defmodule Keyspace.Keyspace.Delete.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Keyspace.KeyspaceService.Service do
  @moduledoc false
  use GRPC.Service, name: "keyspace.KeyspaceService"

  rpc :retrieve, Keyspace.Keyspace.Retrieve.Req, Keyspace.Keyspace.Retrieve.Res
  rpc :delete, Keyspace.Keyspace.Delete.Req, Keyspace.Keyspace.Delete.Res
end

defmodule Keyspace.KeyspaceService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Keyspace.KeyspaceService.Service
end
