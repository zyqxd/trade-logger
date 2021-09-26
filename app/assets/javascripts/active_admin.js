//= require active_admin/base
//= require best_in_place

$(document).ready(function () {
  /* Activating Best In Place */
  $(".best_in_place").best_in_place();
  $(".best_in_place").bind("ajax:success", function () {
    if ($(this).data("reload") === true) location.reload();
  });
});
