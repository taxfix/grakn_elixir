defmodule Session.Answer do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          answer: {atom, any}
        }
  defstruct [:answer]

  oneof(:answer, 0)
  field(:answerGroup, 1, type: Session.AnswerGroup, oneof: 0)
  field(:conceptMap, 2, type: Session.ConceptMap, oneof: 0)
  field(:conceptList, 3, type: Session.ConceptList, oneof: 0)
  field(:conceptSet, 4, type: Session.ConceptSet, oneof: 0)
  field(:conceptSetMeasure, 5, type: Session.ConceptSetMeasure, oneof: 0)
  field(:value, 6, type: Session.Value, oneof: 0)
end

defmodule Session.Explanation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          pattern: String.t(),
          answers: [Session.ConceptMap.t()]
        }
  defstruct [:pattern, :answers]

  field(:pattern, 1, type: :string)
  field(:answers, 2, repeated: true, type: Session.ConceptMap)
end

defmodule Session.AnswerGroup do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          owner: Session.Concept.t(),
          answers: [Session.Answer.t()],
          explanation: Session.Explanation.t()
        }
  defstruct [:owner, :answers, :explanation]

  field(:owner, 1, type: Session.Concept)
  field(:answers, 2, repeated: true, type: Session.Answer)
  field(:explanation, 3, type: Session.Explanation)
end

defmodule Session.ConceptMap do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          map: %{String.t() => Session.Concept.t()},
          explanation: Session.Explanation.t()
        }
  defstruct [:map, :explanation]

  field(:map, 1, repeated: true, type: Session.ConceptMap.MapEntry, map: true)
  field(:explanation, 2, type: Session.Explanation)
end

defmodule Session.ConceptMap.MapEntry do
  @moduledoc false
  use Protobuf, map: true, syntax: :proto3

  @type t :: %__MODULE__{
          key: String.t(),
          value: Session.Concept.t()
        }
  defstruct [:key, :value]

  field(:key, 1, type: :string)
  field(:value, 2, type: Session.Concept)
end

defmodule Session.ConceptList do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          list: Session.ConceptIds.t(),
          explanation: Session.Explanation.t()
        }
  defstruct [:list, :explanation]

  field(:list, 1, type: Session.ConceptIds)
  field(:explanation, 2, type: Session.Explanation)
end

defmodule Session.ConceptSet do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          set: Session.ConceptIds.t(),
          explanation: Session.Explanation.t()
        }
  defstruct [:set, :explanation]

  field(:set, 1, type: Session.ConceptIds)
  field(:explanation, 2, type: Session.Explanation)
end

defmodule Session.ConceptSetMeasure do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          set: Session.ConceptIds.t(),
          measurement: Session.Number.t(),
          explanation: Session.Explanation.t()
        }
  defstruct [:set, :measurement, :explanation]

  field(:set, 1, type: Session.ConceptIds)
  field(:measurement, 2, type: Session.Number)
  field(:explanation, 3, type: Session.Explanation)
end

defmodule Session.Value do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          number: Session.Number.t(),
          explanation: Session.Explanation.t()
        }
  defstruct [:number, :explanation]

  field(:number, 1, type: Session.Number)
  field(:explanation, 2, type: Session.Explanation)
end

defmodule Session.ConceptIds do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          ids: [String.t()]
        }
  defstruct [:ids]

  field(:ids, 1, repeated: true, type: :string)
end

defmodule Session.Number do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: String.t()
        }
  defstruct [:value]

  field(:value, 1, type: :string)
end
