//= require active_admin/base
//= require activeadmin_addons/all
//= require best_in_place
//= require chartkick
//= require Chart.bundle

$(document).ready(function () {
  /* Activating Best In Place */
  $(".best_in_place").best_in_place();
  $(".best_in_place").bind("ajax:success", function () {
    if ($(this).data("reload") === true) location.reload();
  });

  // NOTE(DZ): Ajax fetch plan sidebar
  $("#trade_entry_plan_id").on("change", function (e) {
    const $sidebar = $("#plan_sidebar_section");
    if (!$sidebar || isNaN(e.target.value)) {
      return;
    }

    $.ajax({
      url: `/admin/plans/${e.target.value}.json`,
      type: "GET",
      cache: false,
      success: function (plan) {
        replaceSidebarTableRow($sidebar, "tr.row-plan", plan.name);
        Object.keys(plan).forEach(function (key) {
          replaceSidebarTableRow($sidebar, `tr.row-${key}`, plan[key]);
        });
      },
      error: function (response) {
        alert(response.statusText);
        $this.text(buttonText);
      },
    });
  });
});

function replaceSidebarTableRow(sidebar, rowKey, value) {
  sidebar.find(`${rowKey} td`).last().remove();
  sidebar.find(rowKey).append(`<td>${value}</td>`);
}
