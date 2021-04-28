# frozen_string_literal: true

class ListBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :position
end
