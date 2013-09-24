// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require hamlcoffee
//= require ../../../vendor/assets/javascripts/bootstrap
//= require ejs
//= require underscore
//= require jcarousel.min
//= require backbone
//= require backbone-ui-min
//= require backbone-mediator
//= require underscore.string.min
//= require ../../../vendor/assets/javascripts/slimbox2
//= require_tree ./templates/

//= require apps/admin/admin_app
//= require_tree ./apps/admin/models/
//= require_tree ./apps/admin/collections/
//= require_tree ./apps/admin/views/
//= require_tree ./apps/admin/routers/

//= require apps/people/people_app
//= require_tree ./apps/people/models/
//= require_tree ./apps/people/collections/
//= require_tree ./apps/people/views/
//= require_tree ./apps/people/routers/

//= require apps/dashboard/dashboard_app
//= require_tree ./apps/dashboard/models/
//= require_tree ./apps/dashboard/collections/
//= require_tree ./apps/dashboard/views/
//= require_tree ./apps/dashboard/routers/

//= require apps/movies/movies_app
//= require_tree ./apps/movies/models/
//= require_tree ./apps/movies/collections/
//= require_tree ./apps/movies/views/
//= require_tree ./apps/movies/routers/
//= require moment

//= require_tree .
