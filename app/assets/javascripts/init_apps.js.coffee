window.root_path = "http://localhost:3000/"
$(document).ready ->
  $.ajax "/api/v1/users/get_current_user",
    success: (data) ->
      window.current_user = data.user
      window.DashboardApp.initialize()
      window.PeopleApp.initialize()
      window.MoviesApp.initialize()
