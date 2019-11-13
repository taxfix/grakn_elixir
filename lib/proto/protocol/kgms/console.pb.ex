defmodule UserManagement do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule UserManagement.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          req: {atom, any}
        }
  defstruct [:req]

  oneof :req, 0
  field :login_req, 1, type: Login.Req, oneof: 0
  field :create_req, 2, type: Create.Req, oneof: 0
  field :delete_req, 3, type: Delete.Req, oneof: 0
  field :retrieve_req, 4, type: Retrieve.Req, oneof: 0
  field :retrieve_all_req, 5, type: RetrieveAll.Req, oneof: 0
  field :update_req, 6, type: Update.Req, oneof: 0
end

defmodule UserManagement.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof :res, 0
  field :login_res, 1, type: Login.Res, oneof: 0
  field :create_res, 2, type: Create.Res, oneof: 0
  field :delete_res, 3, type: Delete.Res, oneof: 0
  field :retrieve_res, 4, type: Retrieve.Res, oneof: 0
  field :retrieve_all_res, 5, type: RetrieveAll.Res, oneof: 0
  field :update_res, 6, type: Update.Res, oneof: 0
end

defmodule Login do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Login.Req do
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

defmodule Login.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Create do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Create.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t(),
          password: String.t(),
          role: String.t()
        }
  defstruct [:username, :password, :role]

  field :username, 1, type: :string
  field :password, 2, type: :string
  field :role, 3, type: :string
end

defmodule Create.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user: User.t() | nil
        }
  defstruct [:user]

  field :user, 1, type: User
end

defmodule Delete do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Delete.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t()
        }
  defstruct [:username]

  field :username, 1, type: :string
end

defmodule Delete.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t()
        }
  defstruct [:username]

  field :username, 1, type: :string
end

defmodule Retrieve do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Retrieve.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t()
        }
  defstruct [:username]

  field :username, 1, type: :string
end

defmodule Retrieve.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user: User.t() | nil
        }
  defstruct [:user]

  field :user, 1, type: User
end

defmodule RetrieveAll do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule RetrieveAll.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule RetrieveAll.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          users: [User.t()]
        }
  defstruct [:users]

  field :users, 1, repeated: true, type: User
end

defmodule Update do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Update.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t(),
          password: String.t(),
          role: String.t()
        }
  defstruct [:username, :password, :role]

  field :username, 1, type: :string
  field :password, 2, type: :string
  field :role, 3, type: :string
end

defmodule Update.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          user: User.t() | nil
        }
  defstruct [:user]

  field :user, 1, type: User
end

defmodule User do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          username: String.t(),
          role: String.t()
        }
  defstruct [:username, :role]

  field :username, 1, type: :string
  field :role, 2, type: :string
end

defmodule KGMSConsole.Service do
  @moduledoc false
  use GRPC.Service, name: "KGMSConsole"

  rpc :UserManagement, stream(UserManagement.Req), stream(UserManagement.Res)
end

defmodule KGMSConsole.Stub do
  @moduledoc false
  use GRPC.Stub, service: KGMSConsole.Service
end
