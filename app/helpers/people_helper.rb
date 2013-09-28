module PeopleHelper

  def filter_results(people)
    original_ids = []
    people.each_with_index do |person, i|
      if original_ids.include?(person.original_id)
        people[i] = ""
      else
        original_ids << person.original_id
      end
    end
    people.reject! { |c| c == "" }
    people
  end

end

