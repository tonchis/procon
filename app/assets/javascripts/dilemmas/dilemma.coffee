class window.Dilemma
  constructor: (attrs) ->
    attrs.reasons?= []

    @id      = attrs.id
    @name    = ko.observable attrs.name
    @pros    = ko.observableArray DilemmasHelper.select_reasons(attrs.reasons, "pro")
    @cons    = ko.observableArray DilemmasHelper.select_reasons(attrs.reasons, "con")
    @dilemma = ko.computed =>
      id: @id
      name: @name()
      reasons: $.merge(DilemmasHelper.stringify_array(@pros()),
                       DilemmasHelper.stringify_array(@cons()))

    @new_reason = ko.observable ""

  # Events
  add_pro: ->
    @pros.push text: @new_reason(), type: "pro"
    @new_reason ""
  add_con: ->
    @cons.push text: @new_reason(), type: "con"
    @new_reason ""
  add_both: ->
    @pros.push text: @new_reason(), type: "pro"
    @cons.push text: @new_reason(), type: "con"
    @new_reason ""
  delete_pro: (pro) => DilemmasHelper.delete_reason(pro, @pros)
  delete_con: (con) => DilemmasHelper.delete_reason(con, @cons)
  save_dilemma: (dilemma) ->
    $.ajax
      url: "/dilemmas/#{@dilemma().id}"
      type: "PUT"
      data: @dilemma()
      success: ->
        $("#dilemmas").slideDown()
        $("#edit-dilemma").slideUp()
  cancel_edit: (dilemma) ->
    $("#dilemmas").slideDown()
    $("#edit-dilemma").slideUp()

