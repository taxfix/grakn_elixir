defmodule Session.Answer do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          answer: {atom, any}
        }
  defstruct [:answer]

  oneof :answer, 0
  field :answerGroup, 1, type: Session.AnswerGroup, oneof: 0
  field :conceptMap, 2, type: Session.ConceptMap, oneof: 0
  field :conceptList, 3, type: Session.ConceptList, oneof: 0
  field :conceptSet, 4, type: Session.ConceptSet, oneof: 0
  field :conceptSetMeasure, 5, type: Session.ConceptSetMeasure, oneof: 0
  field :value, 6, type: Session.Value, oneof: 0
  field :void, 7, type: Session.Void, oneof: 0
end

defmodule Session.Explanation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{}
  defstruct []
end

defmodule Session.Explanation.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          explainable: Session.ConceptMap.t() | nil
        }
  defstruct [:explainable]

  field :explainable, 1, type: Session.ConceptMap
end

defmodule Session.Explanation.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          explanation: [Session.ConceptMap.t()]
        }
  defstruct [:explanation]

  field :explanation, 1, repeated: true, type: Session.ConceptMap
end

defmodule Session.AnswerGroup do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          owner: Session.Concept.t() | nil,
          answers: [Session.Answer.t()]
        }
  defstruct [:owner, :answers]

  field :owner, 1, type: Session.Concept
  field :answers, 2, repeated: true, type: Session.Answer
end

defmodule Session.ConceptMap do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          map: %{String.t() => Session.Concept.t() | nil},
          pattern: String.t(),
          hasExplanation: boolean
        }
  defstruct [:map, :pattern, :hasExplanation]

  field :map, 1, repeated: true, type: Session.ConceptMap.MapEntry, map: true
  field :pattern, 2, type: :string
  field :hasExplanation, 3, type: :bool
end

defmodule Session.ConceptMap.MapEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Session.Concept.t() | nil
        }
  defstruct [:key, :value]

  field :key, 1, type: :string
  field :value, 2, type: Session.Concept
end

defmodule Session.ConceptList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          list: Session.ConceptIds.t() | nil
        }
  defstruct [:list]

  field :list, 1, type: Session.ConceptIds
end

defmodule Session.ConceptSet do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          set: Session.ConceptIds.t() | nil
        }
  defstruct [:set]

  field :set, 1, type: Session.ConceptIds
end

defmodule Session.ConceptSetMeasure do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          set: Session.ConceptIds.t() | nil,
          measurement: Session.Number.t() | nil
        }
  defstruct [:set, :measurement]

  field :set, 1, type: Session.ConceptIds
  field :measurement, 2, type: Session.Number
end

defmodule Session.Value do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          number: Session.Number.t() | nil
        }
  defstruct [:number]

  field :number, 1, type: Session.Number
end

defmodule Session.Void do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          message: String.t()
        }
  defstruct [:message]

  field :message, 1, type: :string
end

defmodule Session.ConceptIds do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          ids: [String.t()]
        }
  defstruct [:ids]

  field :ids, 1, repeated: true, type: :string
end

defmodule Session.Number do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: String.t()
        }
  defstruct [:value]

  field :value, 1, type: :string
end
