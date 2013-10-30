$(document).ready(function(){
  $(".load-page").click(function(){
    var link = $(this).attr("data-link");
    var tab = $(this).attr("data-tab");
    localStorage.tab = tab;
    window.location = link;
  });
});
