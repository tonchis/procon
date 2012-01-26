#= require knockout-2.0.0
#= require helpers/ko_custom_bindings
#= require helpers/dilemmas_helper
#= require dilemmas/dilemma
#= require dilemmas/dilemmas

$(document).ready(->
  # Request ALL the dilemmas!
  $.ajax
    url: "/dilemmas"
    type: "GET"
    success: (data) =>
      ko.applyBindings new Dilemmas(data), $("#dilemmas")[0]
      $("#dilemmas").show()
      $("#dilemmas ul").on "mouseenter", "li", DilemmasHelper.show_delete
      $("#dilemmas ul").on "mouseleave", "li", DilemmasHelper.hide_delete
)
