
import Model from require 'lapis.db.model'

class Teams extends Model
  @timestamp: true

  @create: =>

class Players extends Model
  @timestamp: true

  @create: (opt) =>
    { :first_name, :last_name } = opt

    if not first_name
      return nil, "missing opt 'first_name'"
    if not last_name
      return nil, "missing opt 'last_name'"

    Model.create @, {
      :first_name
      :last_name
    }

  @delete: (...) =>
    opt = ...
    id, first_name, last_name = opt[1], "", ""

    unless opt[2] and id
      first_name = id
      last_name = opt[2]

    print "Deleting: #{opt}"

class Matches extends Model
  @timestamp: true

{
  :Teams, :Players, :Matches
}
