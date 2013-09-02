window.root_path = "http://localhost:3000"
window.api_version = "/api/v1/"
window.hide_delay = 5000
$(document).ready ->
  $.ajax "/api/v1/users/get_current_user",
    success: (data) ->
      window.current_user = data.user
      window.DashboardApp.initialize()
      window.PeopleApp.initialize()
      window.AdminApp.initialize()
      window.MoviesApp.initialize()

  $(".notice").addClass("notifications").show().fadeOut(window.hide_delay)
