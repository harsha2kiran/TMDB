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

  $('.datatable').dataTable({
    "sDom": "<'row'<'col-md-6'l><'span6'f>r>t<'row-fluid'<'span6'i><'span6'p>>",
    "sPaginationType": "bootstrap"
  })

  $(".alert").fadeOut(window.hide_delay)

window.check_autocomplete = (items, term, type) ->
  found = false
  term = term.toLowerCase()
  $.each items, (i, item) ->
    if item.label.toLowerCase() == term
      found = true
  if found == false
    items.push { "label" : "Missing #{type}? Add it.", "value" : "Missing #{type}? Add it.", "id" : "0" }
  items

window.check_tags_autocomplete = (items, term, type) ->
  found_movie = false
  found_person = false
  found_company = false
  term = term.toLowerCase()
  $.each items, (i, item) ->
    if item.label.toLowerCase() == term
      if item.type == "Movie"
        found_movie = true
      if item.type == "Person"
        found_person = true
      if item.type == "Company"
        found_company = true
  if found_movie == false
    items.push { "label" : "Missing movie? Add it.", "value" : "Missing movie? Add it.", "id" : "-1" }
  if found_person == false
    items.push { "label" : "Missing person? Add it.", "value" : "Missing person? Add it.", "id" : "-2" }
  if found_company == false
    items.push { "label" : "Missing company? Add it.", "value" : "Missing company? Add it.", "id" : "-3" }
  items

window.is_admin_or_mod = ->
  if (current_user && (current_user.user_type == "admin" || current_user.user_type == "moderator"))
    true
  else
    false

window.current_users_item = (item) ->
  if (current_user && item.user_id == current_user.id)
    true
  else
    false

window.current_temp_users_item = (item) ->
  if (item.temp_user_id == localStorage.temp_user_id)
    true
  else
    false

window.sort_priority = (a, b) ->
  return -1  if a.list_item.images[0].priority < b.list_item.images[0].priority
  return 1  if a.list_item.images[0].priority > b.list_item.images[0].priority
  0
