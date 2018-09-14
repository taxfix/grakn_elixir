defmodule Session.Method do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Method.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          req: {atom, any}
        }
  defstruct [:req]

  oneof(:req, 0)
  field(:concept_delete_req, 100, type: Session.Concept.Delete.Req, oneof: 0)
  field(:schemaConcept_isImplicit_req, 200, type: Session.SchemaConcept.IsImplicit.Req, oneof: 0)
  field(:schemaConcept_getLabel_req, 201, type: Session.SchemaConcept.GetLabel.Req, oneof: 0)
  field(:schemaConcept_setLabel_req, 202, type: Session.SchemaConcept.SetLabel.Req, oneof: 0)
  field(:schemaConcept_getSup_req, 203, type: Session.SchemaConcept.GetSup.Req, oneof: 0)
  field(:schemaConcept_setSup_req, 204, type: Session.SchemaConcept.SetSup.Req, oneof: 0)
  field(:schemaConcept_sups_req, 205, type: Session.SchemaConcept.Sups.Req, oneof: 0)
  field(:schemaConcept_subs_req, 206, type: Session.SchemaConcept.Subs.Req, oneof: 0)
  field(:rule_when_req, 300, type: Session.Rule.When.Req, oneof: 0)
  field(:rule_then_req, 301, type: Session.Rule.Then.Req, oneof: 0)
  field(:role_relations_req, 401, type: Session.Role.Relations.Req, oneof: 0)
  field(:role_players_req, 402, type: Session.Role.Players.Req, oneof: 0)
  field(:type_isAbstract_req, 500, type: Session.Type.IsAbstract.Req, oneof: 0)
  field(:type_setAbstract_req, 501, type: Session.Type.SetAbstract.Req, oneof: 0)
  field(:type_instances_req, 502, type: Session.Type.Instances.Req, oneof: 0)
  field(:type_keys_req, 503, type: Session.Type.Keys.Req, oneof: 0)
  field(:type_attributes_req, 504, type: Session.Type.Attributes.Req, oneof: 0)
  field(:type_playing_req, 505, type: Session.Type.Playing.Req, oneof: 0)
  field(:type_has_req, 506, type: Session.Type.Has.Req, oneof: 0)
  field(:type_key_req, 507, type: Session.Type.Key.Req, oneof: 0)
  field(:type_plays_req, 508, type: Session.Type.Plays.Req, oneof: 0)
  field(:type_unhas_req, 509, type: Session.Type.Unhas.Req, oneof: 0)
  field(:type_unkey_req, 510, type: Session.Type.Unkey.Req, oneof: 0)
  field(:type_unplay_req, 511, type: Session.Type.Unplay.Req, oneof: 0)
  field(:entityType_create_req, 600, type: Session.EntityType.Create.Req, oneof: 0)
  field(:relationType_create_req, 700, type: Session.RelationType.Create.Req, oneof: 0)
  field(:relationType_roles_req, 701, type: Session.RelationType.Roles.Req, oneof: 0)
  field(:relationType_relates_req, 702, type: Session.RelationType.Relates.Req, oneof: 0)
  field(:relationType_unrelate_req, 703, type: Session.RelationType.Unrelate.Req, oneof: 0)
  field(:attributeType_create_req, 800, type: Session.AttributeType.Create.Req, oneof: 0)
  field(:attributeType_attribute_req, 801, type: Session.AttributeType.Attribute.Req, oneof: 0)
  field(:attributeType_dataType_req, 802, type: Session.AttributeType.DataType.Req, oneof: 0)
  field(:attributeType_getRegex_req, 803, type: Session.AttributeType.GetRegex.Req, oneof: 0)
  field(:attributeType_setRegex_req, 804, type: Session.AttributeType.SetRegex.Req, oneof: 0)
  field(:thing_type_req, 900, type: Session.Thing.Type.Req, oneof: 0)
  field(:thing_isInferred_req, 901, type: Session.Thing.IsInferred.Req, oneof: 0)
  field(:thing_keys_req, 902, type: Session.Thing.Keys.Req, oneof: 0)
  field(:thing_attributes_req, 903, type: Session.Thing.Attributes.Req, oneof: 0)
  field(:thing_relations_req, 904, type: Session.Thing.Relations.Req, oneof: 0)
  field(:thing_roles_req, 905, type: Session.Thing.Roles.Req, oneof: 0)
  field(:thing_relhas_req, 906, type: Session.Thing.Relhas.Req, oneof: 0)
  field(:thing_unhas_req, 907, type: Session.Thing.Unhas.Req, oneof: 0)
  field(:relation_rolePlayersMap_req, 1000, type: Session.Relation.RolePlayersMap.Req, oneof: 0)
  field(:relation_rolePlayers_req, 1001, type: Session.Relation.RolePlayers.Req, oneof: 0)
  field(:relation_assign_req, 1002, type: Session.Relation.Assign.Req, oneof: 0)
  field(:relation_unassign_req, 1003, type: Session.Relation.Unassign.Req, oneof: 0)
  field(:attribute_value_req, 1100, type: Session.Attribute.Value.Req, oneof: 0)
  field(:attribute_owners_req, 1101, type: Session.Attribute.Owners.Req, oneof: 0)
end

defmodule Session.Method.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof(:res, 0)
  field(:concept_delete_res, 100, type: Session.Concept.Delete.Res, oneof: 0)
  field(:schemaConcept_isImplicit_res, 200, type: Session.SchemaConcept.IsImplicit.Res, oneof: 0)
  field(:schemaConcept_getLabel_res, 201, type: Session.SchemaConcept.GetLabel.Res, oneof: 0)
  field(:schemaConcept_setLabel_res, 202, type: Session.SchemaConcept.SetLabel.Res, oneof: 0)
  field(:schemaConcept_getSup_res, 203, type: Session.SchemaConcept.GetSup.Res, oneof: 0)
  field(:schemaConcept_setSup_res, 204, type: Session.SchemaConcept.SetSup.Res, oneof: 0)
  field(:schemaConcept_sups_iter, 205, type: Session.SchemaConcept.Sups.Iter, oneof: 0)
  field(:schemaConcept_subs_iter, 206, type: Session.SchemaConcept.Subs.Iter, oneof: 0)
  field(:rule_when_res, 300, type: Session.Rule.When.Res, oneof: 0)
  field(:rule_then_res, 301, type: Session.Rule.Then.Res, oneof: 0)
  field(:role_relations_iter, 401, type: Session.Role.Relations.Iter, oneof: 0)
  field(:role_players_iter, 402, type: Session.Role.Players.Iter, oneof: 0)
  field(:type_isAbstract_res, 500, type: Session.Type.IsAbstract.Res, oneof: 0)
  field(:type_setAbstract_res, 501, type: Session.Type.SetAbstract.Res, oneof: 0)
  field(:type_instances_iter, 502, type: Session.Type.Instances.Iter, oneof: 0)
  field(:type_keys_iter, 503, type: Session.Type.Keys.Iter, oneof: 0)
  field(:type_attributes_iter, 504, type: Session.Type.Attributes.Iter, oneof: 0)
  field(:type_playing_iter, 505, type: Session.Type.Playing.Iter, oneof: 0)
  field(:type_has_res, 506, type: Session.Type.Has.Res, oneof: 0)
  field(:type_key_res, 507, type: Session.Type.Key.Res, oneof: 0)
  field(:type_plays_res, 508, type: Session.Type.Plays.Res, oneof: 0)
  field(:type_unhas_res, 509, type: Session.Type.Unhas.Res, oneof: 0)
  field(:type_unkey_res, 510, type: Session.Type.Unkey.Res, oneof: 0)
  field(:type_unplay_res, 511, type: Session.Type.Unplay.Res, oneof: 0)
  field(:entityType_create_res, 600, type: Session.EntityType.Create.Res, oneof: 0)
  field(:relationType_create_res, 700, type: Session.RelationType.Create.Res, oneof: 0)
  field(:relationType_roles_iter, 701, type: Session.RelationType.Roles.Iter, oneof: 0)
  field(:relationType_relates_res, 702, type: Session.RelationType.Relates.Res, oneof: 0)
  field(:relationType_unrelate_res, 703, type: Session.RelationType.Unrelate.Res, oneof: 0)
  field(:attributeType_create_res, 800, type: Session.AttributeType.Create.Res, oneof: 0)
  field(:attributeType_attribute_res, 801, type: Session.AttributeType.Attribute.Res, oneof: 0)
  field(:attributeType_dataType_res, 802, type: Session.AttributeType.DataType.Res, oneof: 0)
  field(:attributeType_getRegex_res, 803, type: Session.AttributeType.GetRegex.Res, oneof: 0)
  field(:attributeType_setRegex_res, 804, type: Session.AttributeType.SetRegex.Res, oneof: 0)
  field(:thing_type_res, 900, type: Session.Thing.Type.Res, oneof: 0)
  field(:thing_isInferred_res, 901, type: Session.Thing.IsInferred.Res, oneof: 0)
  field(:thing_keys_iter, 902, type: Session.Thing.Keys.Iter, oneof: 0)
  field(:thing_attributes_iter, 903, type: Session.Thing.Attributes.Iter, oneof: 0)
  field(:thing_relations_iter, 904, type: Session.Thing.Relations.Iter, oneof: 0)
  field(:thing_roles_iter, 905, type: Session.Thing.Roles.Iter, oneof: 0)
  field(:thing_relhas_res, 906, type: Session.Thing.Relhas.Res, oneof: 0)
  field(:thing_unhas_res, 907, type: Session.Thing.Unhas.Res, oneof: 0)
  field(:relation_rolePlayersMap_iter, 1000, type: Session.Relation.RolePlayersMap.Iter, oneof: 0)
  field(:relation_rolePlayers_iter, 1001, type: Session.Relation.RolePlayers.Iter, oneof: 0)
  field(:relation_assign_res, 1002, type: Session.Relation.Assign.Res, oneof: 0)
  field(:relation_unassign_res, 1003, type: Session.Relation.Unassign.Res, oneof: 0)
  field(:attribute_value_res, 1100, type: Session.Attribute.Value.Res, oneof: 0)
  field(:attribute_owners_iter, 1101, type: Session.Attribute.Owners.Iter, oneof: 0)
end

defmodule Session.Method.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Method.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          schemaConcept_sups_iter_res: Session.SchemaConcept.Sups.Iter.Res.t(),
          schemaConcept_subs_iter_res: Session.SchemaConcept.Subs.Iter.Res.t(),
          role_relations_iter_res: Session.Role.Relations.Iter.Res.t(),
          role_players_iter_res: Session.Role.Players.Iter.Res.t(),
          type_instances_iter_res: Session.Type.Instances.Iter.Res.t(),
          type_keys_iter_res: Session.Type.Keys.Iter.Res.t(),
          type_attributes_iter_res: Session.Type.Attributes.Iter.Res.t(),
          type_playing_iter_res: Session.Type.Playing.Iter.Res.t(),
          relationType_roles_iter_res: Session.RelationType.Roles.Iter.Res.t(),
          thing_keys_iter_res: Session.Thing.Keys.Iter.Res.t(),
          thing_attributes_iter_res: Session.Thing.Attributes.Iter.Res.t(),
          thing_relations_iter_res: Session.Thing.Relations.Iter.Res.t(),
          thing_roles_iter_res: Session.Thing.Roles.Iter.Res.t(),
          relation_rolePlayersMap_iter_res: Session.Relation.RolePlayersMap.Iter.Res.t(),
          relation_rolePlayers_iter_res: Session.Relation.RolePlayers.Iter.Res.t(),
          attribute_owners_iter_res: Session.Attribute.Owners.Iter.Res.t()
        }
  defstruct [
    :schemaConcept_sups_iter_res,
    :schemaConcept_subs_iter_res,
    :role_relations_iter_res,
    :role_players_iter_res,
    :type_instances_iter_res,
    :type_keys_iter_res,
    :type_attributes_iter_res,
    :type_playing_iter_res,
    :relationType_roles_iter_res,
    :thing_keys_iter_res,
    :thing_attributes_iter_res,
    :thing_relations_iter_res,
    :thing_roles_iter_res,
    :relation_rolePlayersMap_iter_res,
    :relation_rolePlayers_iter_res,
    :attribute_owners_iter_res
  ]

  field(:schemaConcept_sups_iter_res, 205, type: Session.SchemaConcept.Sups.Iter.Res)
  field(:schemaConcept_subs_iter_res, 206, type: Session.SchemaConcept.Subs.Iter.Res)
  field(:role_relations_iter_res, 401, type: Session.Role.Relations.Iter.Res)
  field(:role_players_iter_res, 402, type: Session.Role.Players.Iter.Res)
  field(:type_instances_iter_res, 502, type: Session.Type.Instances.Iter.Res)
  field(:type_keys_iter_res, 503, type: Session.Type.Keys.Iter.Res)
  field(:type_attributes_iter_res, 504, type: Session.Type.Attributes.Iter.Res)
  field(:type_playing_iter_res, 505, type: Session.Type.Playing.Iter.Res)
  field(:relationType_roles_iter_res, 701, type: Session.RelationType.Roles.Iter.Res)
  field(:thing_keys_iter_res, 902, type: Session.Thing.Keys.Iter.Res)
  field(:thing_attributes_iter_res, 903, type: Session.Thing.Attributes.Iter.Res)
  field(:thing_relations_iter_res, 904, type: Session.Thing.Relations.Iter.Res)
  field(:thing_roles_iter_res, 905, type: Session.Thing.Roles.Iter.Res)
  field(:relation_rolePlayersMap_iter_res, 1000, type: Session.Relation.RolePlayersMap.Iter.Res)
  field(:relation_rolePlayers_iter_res, 1001, type: Session.Relation.RolePlayers.Iter.Res)
  field(:attribute_owners_iter_res, 1101, type: Session.Attribute.Owners.Iter.Res)
end

defmodule Session.Null do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Concept do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: String.t(),
          baseType: integer
        }
  defstruct [:id, :baseType]

  field(:id, 1, type: :string)
  field(:baseType, 2, type: Session.Concept.BASE_TYPE, enum: true)
end

defmodule Session.Concept.Delete do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Concept.Delete.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Concept.Delete.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Concept.BASE_TYPE do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:META_TYPE, 0)
  field(:ENTITY_TYPE, 1)
  field(:RELATION_TYPE, 2)
  field(:ATTRIBUTE_TYPE, 3)
  field(:ROLE, 4)
  field(:RULE, 5)
  field(:ENTITY, 6)
  field(:RELATION, 7)
  field(:ATTRIBUTE, 8)
end

defmodule Session.SchemaConcept do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.GetLabel do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.GetLabel.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.GetLabel.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t()
        }
  defstruct [:label]

  field(:label, 1, type: :string)
end

defmodule Session.SchemaConcept.SetLabel do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.SetLabel.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          label: String.t()
        }
  defstruct [:label]

  field(:label, 1, type: :string)
end

defmodule Session.SchemaConcept.SetLabel.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.IsImplicit do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.IsImplicit.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.IsImplicit.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          implicit: boolean
        }
  defstruct [:implicit]

  field(:implicit, 1, type: :bool)
end

defmodule Session.SchemaConcept.GetSup do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.GetSup.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.GetSup.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof(:res, 0)
  field(:schemaConcept, 1, type: Session.Concept, oneof: 0)
  field(:null, 2, type: Session.Null, oneof: 0)
end

defmodule Session.SchemaConcept.SetSup do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.SetSup.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          schemaConcept: Session.Concept.t()
        }
  defstruct [:schemaConcept]

  field(:schemaConcept, 1, type: Session.Concept)
end

defmodule Session.SchemaConcept.SetSup.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.Sups do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.Sups.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.Sups.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.SchemaConcept.Sups.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          schemaConcept: Session.Concept.t()
        }
  defstruct [:schemaConcept]

  field(:schemaConcept, 1, type: Session.Concept)
end

defmodule Session.SchemaConcept.Subs do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.Subs.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.SchemaConcept.Subs.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.SchemaConcept.Subs.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          schemaConcept: Session.Concept.t()
        }
  defstruct [:schemaConcept]

  field(:schemaConcept, 1, type: Session.Concept)
end

defmodule Session.Rule do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Rule.When do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Rule.When.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Rule.When.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof(:res, 0)
  field(:pattern, 1, type: :string, oneof: 0)
  field(:null, 2, type: Session.Null, oneof: 0)
end

defmodule Session.Rule.Then do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Rule.Then.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Rule.Then.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof(:res, 0)
  field(:pattern, 1, type: :string, oneof: 0)
  field(:null, 2, type: Session.Null, oneof: 0)
end

defmodule Session.Role do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Role.Relations do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Role.Relations.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Role.Relations.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Role.Relations.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          relationType: Session.Concept.t()
        }
  defstruct [:relationType]

  field(:relationType, 1, type: Session.Concept)
end

defmodule Session.Role.Players do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Role.Players.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Role.Players.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Role.Players.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: Session.Concept.t()
        }
  defstruct [:type]

  field(:type, 1, type: Session.Concept)
end

defmodule Session.Type do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.IsAbstract do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.IsAbstract.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.IsAbstract.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          abstract: boolean
        }
  defstruct [:abstract]

  field(:abstract, 1, type: :bool)
end

defmodule Session.Type.SetAbstract do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.SetAbstract.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          abstract: boolean
        }
  defstruct [:abstract]

  field(:abstract, 1, type: :bool)
end

defmodule Session.Type.SetAbstract.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Instances do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Instances.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Instances.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Type.Instances.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          thing: Session.Concept.t()
        }
  defstruct [:thing]

  field(:thing, 1, type: Session.Concept)
end

defmodule Session.Type.Attributes do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Attributes.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Attributes.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Type.Attributes.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field(:attributeType, 1, type: Session.Concept)
end

defmodule Session.Type.Keys do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Keys.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Keys.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Type.Keys.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field(:attributeType, 1, type: Session.Concept)
end

defmodule Session.Type.Playing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Playing.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Playing.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Type.Playing.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.Type.Key do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Key.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field(:attributeType, 1, type: Session.Concept)
end

defmodule Session.Type.Key.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Has do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Has.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field(:attributeType, 1, type: Session.Concept)
end

defmodule Session.Type.Has.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Plays do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Plays.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.Type.Plays.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Unkey do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Unkey.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field(:attributeType, 1, type: Session.Concept)
end

defmodule Session.Type.Unkey.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Unhas do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Unhas.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeType: Session.Concept.t()
        }
  defstruct [:attributeType]

  field(:attributeType, 1, type: Session.Concept)
end

defmodule Session.Type.Unhas.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Unplay do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Type.Unplay.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.Type.Unplay.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.EntityType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.EntityType.Create do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.EntityType.Create.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.EntityType.Create.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          entity: Session.Concept.t()
        }
  defstruct [:entity]

  field(:entity, 1, type: Session.Concept)
end

defmodule Session.RelationType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Create do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Create.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Create.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          relation: Session.Concept.t()
        }
  defstruct [:relation]

  field(:relation, 1, type: Session.Concept)
end

defmodule Session.RelationType.Roles do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Roles.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Roles.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.RelationType.Roles.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.RelationType.Relates do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Relates.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.RelationType.Relates.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Unrelate do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.RelationType.Unrelate.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.RelationType.Unrelate.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.Create do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.Create.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: Session.ValueObject.t()
        }
  defstruct [:value]

  field(:value, 1, type: Session.ValueObject)
end

defmodule Session.AttributeType.Create.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attribute: Session.Concept.t()
        }
  defstruct [:attribute]

  field(:attribute, 1, type: Session.Concept)
end

defmodule Session.AttributeType.Attribute do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.Attribute.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: Session.ValueObject.t()
        }
  defstruct [:value]

  field(:value, 1, type: Session.ValueObject)
end

defmodule Session.AttributeType.Attribute.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof(:res, 0)
  field(:attribute, 1, type: Session.Concept, oneof: 0)
  field(:null, 2, type: Session.Null, oneof: 0)
end

defmodule Session.AttributeType.DataType do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.DataType.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.DataType.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          res: {atom, any}
        }
  defstruct [:res]

  oneof(:res, 0)
  field(:dataType, 1, type: Session.AttributeType.DATA_TYPE, enum: true, oneof: 0)
  field(:null, 2, type: Session.Null, oneof: 0)
end

defmodule Session.AttributeType.GetRegex do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.GetRegex.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.GetRegex.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          regex: String.t()
        }
  defstruct [:regex]

  field(:regex, 1, type: :string)
end

defmodule Session.AttributeType.SetRegex do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.SetRegex.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          regex: String.t()
        }
  defstruct [:regex]

  field(:regex, 1, type: :string)
end

defmodule Session.AttributeType.SetRegex.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.AttributeType.DATA_TYPE do
  @moduledoc false
  use Protobuf, enum: true, syntax: :proto3

  field(:STRING, 0)
  field(:BOOLEAN, 1)
  field(:INTEGER, 2)
  field(:LONG, 3)
  field(:FLOAT, 4)
  field(:DOUBLE, 5)
  field(:DATE, 6)
end

defmodule Session.Thing do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.IsInferred do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.IsInferred.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.IsInferred.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          inferred: boolean
        }
  defstruct [:inferred]

  field(:inferred, 1, type: :bool)
end

defmodule Session.Thing.Type do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Type.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Type.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          type: Session.Concept.t()
        }
  defstruct [:type]

  field(:type, 1, type: Session.Concept)
end

defmodule Session.Thing.Keys do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Keys.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeTypes: [Session.Concept.t()]
        }
  defstruct [:attributeTypes]

  field(:attributeTypes, 1, repeated: true, type: Session.Concept)
end

defmodule Session.Thing.Keys.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Thing.Keys.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attribute: Session.Concept.t()
        }
  defstruct [:attribute]

  field(:attribute, 1, type: Session.Concept)
end

defmodule Session.Thing.Attributes do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Attributes.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attributeTypes: [Session.Concept.t()]
        }
  defstruct [:attributeTypes]

  field(:attributeTypes, 1, repeated: true, type: Session.Concept)
end

defmodule Session.Thing.Attributes.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Thing.Attributes.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attribute: Session.Concept.t()
        }
  defstruct [:attribute]

  field(:attribute, 1, type: Session.Concept)
end

defmodule Session.Thing.Relations do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Relations.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          roles: [Session.Concept.t()]
        }
  defstruct [:roles]

  field(:roles, 1, repeated: true, type: Session.Concept)
end

defmodule Session.Thing.Relations.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Thing.Relations.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          relation: Session.Concept.t()
        }
  defstruct [:relation]

  field(:relation, 1, type: Session.Concept)
end

defmodule Session.Thing.Roles do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Roles.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Roles.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Thing.Roles.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t()
        }
  defstruct [:role]

  field(:role, 1, type: Session.Concept)
end

defmodule Session.Thing.Relhas do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Relhas.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attribute: Session.Concept.t()
        }
  defstruct [:attribute]

  field(:attribute, 1, type: Session.Concept)
end

defmodule Session.Thing.Relhas.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          relation: Session.Concept.t()
        }
  defstruct [:relation]

  field(:relation, 1, type: Session.Concept)
end

defmodule Session.Thing.Unhas do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Thing.Unhas.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          attribute: Session.Concept.t()
        }
  defstruct [:attribute]

  field(:attribute, 1, type: Session.Concept)
end

defmodule Session.Thing.Unhas.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.RolePlayersMap do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.RolePlayersMap.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.RolePlayersMap.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Relation.RolePlayersMap.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t(),
          player: Session.Concept.t()
        }
  defstruct [:role, :player]

  field(:role, 1, type: Session.Concept)
  field(:player, 2, type: Session.Concept)
end

defmodule Session.Relation.RolePlayers do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.RolePlayers.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          roles: [Session.Concept.t()]
        }
  defstruct [:roles]

  field(:roles, 1, repeated: true, type: Session.Concept)
end

defmodule Session.Relation.RolePlayers.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Relation.RolePlayers.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          thing: Session.Concept.t()
        }
  defstruct [:thing]

  field(:thing, 1, type: Session.Concept)
end

defmodule Session.Relation.Assign do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.Assign.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t(),
          player: Session.Concept.t()
        }
  defstruct [:role, :player]

  field(:role, 1, type: Session.Concept)
  field(:player, 2, type: Session.Concept)
end

defmodule Session.Relation.Assign.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.Unassign do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Relation.Unassign.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          role: Session.Concept.t(),
          player: Session.Concept.t()
        }
  defstruct [:role, :player]

  field(:role, 1, type: Session.Concept)
  field(:player, 2, type: Session.Concept)
end

defmodule Session.Relation.Unassign.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Attribute do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Attribute.Value do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Attribute.Value.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Attribute.Value.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: Session.ValueObject.t()
        }
  defstruct [:value]

  field(:value, 1, type: Session.ValueObject)
end

defmodule Session.Attribute.Owners do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Attribute.Owners.Req do
  @moduledoc false
  use Protobuf, syntax: :proto3

  defstruct []
end

defmodule Session.Attribute.Owners.Iter do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          id: integer
        }
  defstruct [:id]

  field(:id, 1, type: :int32)
end

defmodule Session.Attribute.Owners.Iter.Res do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          thing: Session.Concept.t()
        }
  defstruct [:thing]

  field(:thing, 1, type: Session.Concept)
end

defmodule Session.ValueObject do
  @moduledoc false
  use Protobuf, syntax: :proto3

  @type t :: %__MODULE__{
          value: {atom, any}
        }
  defstruct [:value]

  oneof(:value, 0)
  field(:string, 1, type: :string, oneof: 0)
  field(:boolean, 2, type: :bool, oneof: 0)
  field(:integer, 3, type: :int32, oneof: 0)
  field(:long, 4, type: :int64, oneof: 0)
  field(:float, 5, type: :float, oneof: 0)
  field(:double, 6, type: :double, oneof: 0)
  field(:date, 7, type: :int64, oneof: 0)
end
