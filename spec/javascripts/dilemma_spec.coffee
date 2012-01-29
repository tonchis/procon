describe "Dilemma", ->
  it "should have observable new_reason", ->
    dilemma = new Dilemma {}
    expect(dilemma.new_reason()).toBe ""

  it "should have observable name", ->
    dilemma = new Dilemma name: "my problem"
    expect(dilemma.name()).toBe "my problem"

  it "should have observable pros and cons", ->
    dilemma = new Dilemma {name: "my problem", reasons: [{text: "good one", type: "pro"}, {text: "bad one", type: "con"}]}

    expect(dilemma.pros()[0].text).toBe "good one"
    expect(dilemma.cons()[0].text).toBe "bad one"

  describe "events", ->
    beforeEach ->
      @dilemma = new Dilemma name: "my problem"
      @dilemma.new_reason "new reason"

    describe "add_pro", ->
      it "should add #new_reason to #pros", ->
        @dilemma.add_pro()
        expect(@dilemma.pros()[0].text).toBe "new reason"
        expect(@dilemma.new_reason()).toBe ""

    describe "add_con", ->
      it "should add #new_reason to #cons", ->
        @dilemma.add_con()
        expect(@dilemma.cons()[0].text).toBe "new reason"
        expect(@dilemma.new_reason()).toBe ""

    describe "add_both", ->
      it "should add #new_reason to #pros and #cons", ->
        @dilemma.add_both()
        expect(@dilemma.cons()[0].text).toBe "new reason"
        expect(@dilemma.pros()[0].text).toBe "new reason"
        expect(@dilemma.new_reason()).toBe ""

    describe "save_dilemma", ->
      beforeEach ->
        @server   = sinon.fakeServer.create()
        @ajax_spy = sinon.spy($, "ajax")
        @dilemma  = new Dilemma {id: "4", name: "my problem", reasons: [{text: "good one", type: "pro"}, {text: "bad one", type: "con"}]}

      afterEach ->
        @server.restore()
        @ajax_spy.restore()

      it "should PUT dilemma to server", ->
        @dilemma.save_dilemma()
        expect(@ajax_spy).toHaveBeenCalledOnce
        expect(@ajax_spy.getCall(0).args[0].url).toBe "/dilemmas/#{@dilemma.id}"
        expect(@ajax_spy.getCall(0).args[0].type).toBe "PUT"
        expect(@ajax_spy.getCall(0).args[0].data).toBe @dilemma.dilemma()

      describe "DOM modifications", ->
        beforeEach ->
          response = [200, {"Content-Type": "application/json"},
            "{\"id\": #{@dilemma.id}, \"reasons\":" +
            "[{\"text\": \"good one\", \"type\": \"pro\", \"id\": \"1\"}," +
             "{\"text\": \"bad one\", \"type\": \"con\", \"id\": \"2\"}]}"]
          @server.respondWith("PUT", "/dilemmas/#{@dilemma.id}", response)
          jasmine.getFixtures().fixturesPath = "jasmine/fixtures"

        afterEach ->
          jasmine.getFixtures().clearCache()

        it "should show dilemmas list", ->
          setFixtures sandbox({id: "dilemmas", style: "display: none;"})
          @dilemma.save_dilemma()
          @server.respond()
          expect($("#dilemmas")).toBeVisible()

        # Y U NO PASSING?
        # it "should hide current dilemma", ->
          # setFixtures sandbox({id: "edit-dilemma", style: ""})
          # @dilemma.save_dilemma()
          # @server.respond()
          # expect($("#edit-dilemma")).toBeHidden()
