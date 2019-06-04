defmodule Session.Session do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Session.Open do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Session.Open.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          Keyspace: String.t()
        }
  defstruct [:Keyspace]

  field :Keyspace, 1, type: :string
end

defmodule Session.Session.Open.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          sessionId: String.t()
        }
  defstruct [:sessionId]

  field :sessionId, 1, type: :string
end

defmodule Session.Session.Close do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Session.Close.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          sessionId: String.t()
        }
  defstruct [:sessionId]

  field :sessionId, 1, type: :string
end

defmodule Session.Session.Close.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          req: {atom, any},
          metadata: %{String.t() => String.t()}
        }
  defstruct [:req, :metadata]

  oneof :req, 0
  field :metadata, 1000, repeated: true, type: Session.Transaction.Req.MetadataEntry, map: true
  field :open_req, 1, type: Session.Transaction.Open.Req, oneof: 0
  field :commit_req, 2, type: Session.Transaction.Commit.Req, oneof: 0
  field :query_req, 3, type: Session.Transaction.Query.Req, oneof: 0
  field :iterate_req, 4, type: Session.Transaction.Iter.Req, oneof: 0
  field :getSchemaConcept_req, 5, type: Session.Transaction.GetSchemaConcept.Req, oneof: 0
  field :getConcept_req, 6, type: Session.Transaction.GetConcept.Req, oneof: 0
  field :getAttributes_req, 7, type: Session.Transaction.GetAttributes.Req, oneof: 0
  field :putEntityType_req, 8, type: Session.Transaction.PutEntityType.Req, oneof: 0
  field :putAttributeType_req, 9, type: Session.Transaction.PutAttributeType.Req, oneof: 0
  field :putRelationType_req, 10, type: Session.Transaction.PutRelationType.Req, oneof: 0
  field :putRole_req, 11, type: Session.Transaction.PutRole.Req, oneof: 0
  field :putRule_req, 12, type: Session.Transaction.PutRule.Req, oneof: 0
  field :conceptMethod_req, 13, type: Session.Transaction.ConceptMethod.Req, oneof: 0
end

defmodule Session.Transaction.Req.MetadataEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule Session.Transaction.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any},
          metadata: %{String.t() => String.t()}
        }
  defstruct [:res, :metadata]

  oneof :res, 0
  field :metadata, 1000, repeated: true, type: Session.Transaction.Res.MetadataEntry, map: true
  field :open_res, 1, type: Session.Transaction.Open.Res, oneof: 0
  field :commit_res, 2, type: Session.Transaction.Commit.Res, oneof: 0
  field :query_iter, 3, type: Session.Transaction.Query.Iter, oneof: 0
  field :iterate_res, 4, type: Session.Transaction.Iter.Res, oneof: 0
  field :getSchemaConcept_res, 5, type: Session.Transaction.GetSchemaConcept.Res, oneof: 0
  field :getConcept_res, 6, type: Session.Transaction.GetConcept.Res, oneof: 0
  field :getAttributes_iter, 7, type: Session.Transaction.GetAttributes.Iter, oneof: 0
  field :putEntityType_res, 8, type: Session.Transaction.PutEntityType.Res, oneof: 0
  field :putAttributeType_res, 9, type: Session.Transaction.PutAttributeType.Res, oneof: 0
  field :putRelationType_res, 10, type: Session.Transaction.PutRelationType.Res, oneof: 0
  field :putRole_res, 11, type: Session.Transaction.PutRole.Res, oneof: 0
  field :putRule_res, 12, type: Session.Transaction.PutRule.Res, oneof: 0
  field :conceptMethod_res, 13, type: Session.Transaction.ConceptMethod.Res, oneof: 0
end

defmodule Session.Transaction.Res.MetadataEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: String.t()
        }
  defstruct [:key, :value]

  field :key, 1, type: :string
  field :value, 2, type: :string
end

defmodule Session.Transaction.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Iter.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field :id, 1, type: :int32
end

defmodule Session.Transaction.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof :res, 0
  field :done, 1, type: :bool, oneof: 0
  field :query_iter_res, 2, type: Session.Transaction.Query.Iter.Res, oneof: 0
  field :getAttributes_iter_res, 3, type: Session.Transaction.GetAttributes.Iter.Res, oneof: 0
  field :conceptMethod_iter_res, 4, type: Session.Method.Iter.Res, oneof: 0
end

defmodule Session.Transaction.Open do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Open.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          sessionId: String.t(),
          type: integer,
          username: String.t(),
          password: String.t()
        }
  defstruct [:sessionId, :type, :username, :password]

  field :sessionId, 1, type: :string
  field :type, 2, type: Session.Transaction.Type, enum: true
  field :username, 3, type: :string
  field :password, 4, type: :string
end

defmodule Session.Transaction.Open.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Commit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Commit.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Commit.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Query do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.Query.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          query: String.t(),
          infer: integer
        }
  defstruct [:query, :infer]

  field :query, 1, type: :string
  field :infer, 2, type: Session.Transaction.Query.INFER, enum: true
end

defmodule Session.Transaction.Query.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field :id, 1, type: :int32
end

defmodule Session.Transaction.Query.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          answer: Session.Answer.t()
        }
  defstruct [:answer]

  field :answer, 1, type: Session.Answer
end

defmodule Session.Transaction.Query.INFER do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :TRUE, 0
  field :FALSE, 1
end

defmodule Session.Transaction.GetSchemaConcept do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.GetSchemaConcept.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t()
        }
  defstruct [:label]

  field :label, 1, type: :string
end

defmodule Session.Transaction.GetSchemaConcept.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof :res, 0
  field :schemaConcept, 1, type: Session.Concept, oneof: 0
  field :null, 2, type: Session.Null, oneof: 0
end

defmodule Session.Transaction.GetConcept do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.GetConcept.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: String.t()
        }
  defstruct [:id]

  field :id, 1, type: :string
end

defmodule Session.Transaction.GetConcept.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof :res, 0
  field :concept, 1, type: Session.Concept, oneof: 0
  field :null, 2, type: Session.Null, oneof: 0
end

defmodule Session.Transaction.GetAttributes do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.GetAttributes.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: Session.ValueObject.t()
        }
  defstruct [:value]

  field :value, 1, type: Session.ValueObject
end

defmodule Session.Transaction.GetAttributes.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field :id, 1, type: :int32
end

defmodule Session.Transaction.GetAttributes.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attribute: Session.Concept.t()
        }
  defstruct [:attribute]

  field :attribute, 1, type: Session.Concept
end

defmodule Session.Transaction.PutEntityType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.PutEntityType.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t()
        }
  defstruct [:label]

  field :label, 1, type: :string
end

defmodule Session.Transaction.PutEntityType.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          entityType: Session.Concept.t()
        }
  defstruct [:entityType]

  field :entityType, 1, type: Session.Concept
end

defmodule Session.Transaction.PutAttributeType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.PutAttributeType.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t(),
          dataType: integer
        }
  defstruct [:label, :dataType]

  field :label, 1, type: :string
  field :dataType, 2, type: Session.AttributeType.DATA_TYPE, enum: true
end

defmodule Session.Transaction.PutAttributeType.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field :attributeType, 1, type: Session.Concept
end

defmodule Session.Transaction.PutRelationType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.PutRelationType.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t()
        }
  defstruct [:label]

  field :label, 1, type: :string
end

defmodule Session.Transaction.PutRelationType.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          relationType: Session.Concept.t()
        }
  defstruct [:relationType]

  field :relationType, 1, type: Session.Concept
end

defmodule Session.Transaction.PutRole do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.PutRole.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t()
        }
  defstruct [:label]

  field :label, 1, type: :string
end

defmodule Session.Transaction.PutRole.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field :role, 1, type: Session.Concept
end

defmodule Session.Transaction.PutRule do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.PutRule.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t(),
          when: String.t(),
          then: String.t()
        }
  defstruct [:label, :when, :then]

  field :label, 1, type: :string
  field :when, 2, type: :string
  field :then, 3, type: :string
end

defmodule Session.Transaction.PutRule.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          rule: Session.Concept.t()
        }
  defstruct [:rule]

  field :rule, 1, type: Session.Concept
end

defmodule Session.Transaction.ConceptMethod do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Transaction.ConceptMethod.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: String.t(),
          method: Session.Method.Req.t()
        }
  defstruct [:id, :method]

  field :id, 1, type: :string
  field :method, 2, type: Session.Method.Req
end

defmodule Session.Transaction.ConceptMethod.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          response: Session.Method.Res.t()
        }
  defstruct [:response]

  field :response, 1, type: Session.Method.Res
end

defmodule Session.Transaction.Type do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field :READ, 0
  field :WRITE, 1
  field :BATCH, 2
end

defmodule Session.SessionService.Service do
  @moduledoc false
  use GRPC.Service, name: "session.SessionService"

  rpc :open, Session.Session.Open.Req, Session.Session.Open.Res
  rpc :close, Session.Session.Close.Req, Session.Session.Close.Res
  rpc :transaction, stream(Session.Transaction.Req), stream(Session.Transaction.Res)
end

defmodule Session.SessionService.Stub do
  @moduledoc false
  use GRPC.Stub, service: Session.SessionService.Service
end
