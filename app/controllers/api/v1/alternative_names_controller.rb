class Api::V1::AlternativeNamesController < Api::V1::BaseController

  inherit_resources

  def index
    @alternative_names = AlternativeName.find(:all, include: [:person])
    @people = Person.find_all_by_id @alternative_names.map(&:person_id)
  end

end
