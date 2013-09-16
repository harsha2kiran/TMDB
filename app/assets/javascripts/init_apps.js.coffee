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
      if data.length == 0
        unless localStorage.temp_user_id
          chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
          result = ""
          for i in [25..0]
            result += chars[Math.round(Math.random() * (chars.length - 1))]
          localStorage.temp_user_id = result
      else
        localStorage.removeItem("temp_user_id")

  $(".notice").addClass("notifications").show().fadeOut(window.hide_delay)

  $("body").on "click", ".sign-out", ->
    localStorage.removeItem("temp_user_id")

  $("body").on "click", "a", (e) ->
    unless $(e.target).hasClass("ui-corner-all")
      $(window).scrollTop(0)

  $("body").on "keyup", ".ui-autocomplete-input", (e) ->
    if $(@).val() == ""
      $(".js-new-item-info, .js-new-item-add-form").hide()
      $(".js-new-movie-info, .js-new-movie-add-form").hide()
      $(".js-new-person-info, .js-new-person-add-form").hide()
