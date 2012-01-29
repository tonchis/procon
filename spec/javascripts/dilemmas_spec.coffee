describe "Dilemmas", ->
  it "should have observable new_dilemma", ->
    dilemmas = new Dilemmas {}
    expect(dilemmas.new_dilemma()).toBe ""

  it "should have observable dilemmas", ->
    dilemmas = new Dilemmas [{name: "my problem", reasons: [{text: "good one", type: "pro"}, {text: "bad one", type: "con"}]}]
    expect(dilemmas.dilemmas().length).toBe 1
    expect(dilemmas.dilemmas()[0].name()).toBe "my problem"

  describe "events", ->
    beforeEach ->
      @dilemmas = new Dilemmas [{name: "my problem", reasons: [{text: "good one", type: "pro"}, {text: "bad one", type: "con"}]}]
      @dilemmas.new_dilemma("my new dilemma")

    describe "add_dilemma", ->
      beforeEach ->
        @ajax_spy = sinon.spy($, "ajax")
        @server   = sinon.fakeServer.create()
        response = [200, {"Content-Type": "application/json"},
          "{\"id\": \"10\", \"name\": \"my new dilemma\"}"]
        @server.respondWith("POST", "/dilemmas", response)
        @number_of_dilemmas = @dilemmas.dilemmas().length
        @dilemmas.add_dilemma()
        @server.respond()

      afterEach ->
        @server.restore()
        @ajax_spy.restore()

      it "should POST to /dilemmas", ->
        expect(@ajax_spy).toHaveBeenCalledOnce
        expect(@ajax_spy.getCall(0).args[0].url).toBe "/dilemmas"
        expect(@ajax_spy.getCall(0).args[0].type).toBe "POST"
        expect(@ajax_spy.getCall(0).args[0].data.name).toBe "my new dilemma"

        # expect(@ajax_spy.getCall(0).args[0].data).toBe {name: 'my new dilemma'}
        # The above evaluates to false, though the error message shows:
        # Expected { name : 'my new dilemma' } to be { name : 'my new dilemma' }.
        # Wtf, jasmine?

      it "should add #new_dilemma to #dilemmas", ->
        expect(@dilemmas.dilemmas().length).toBe @number_of_dilemmas + 1
        expect(@dilemmas.dilemmas()[1].name()).toBe "my new dilemma"
        expect(@dilemmas.new_dilemma()).toBe ""

    describe "delete_dilemma", ->
      beforeEach ->
        @dilemma = @dilemmas.dilemmas()[0]
        @dilemma.id = 10

        @ajax_spy = sinon.spy($, "ajax")
        @server   = sinon.fakeServer.create()
        @server.respondWith("DELETE", "/dilemmas/#{@dilemma.id}", [200, {}, ""])

        @number_of_dilemmas = @dilemmas.dilemmas().length
        @dilemmas.delete_dilemma(@dilemma)
        @server.respond()

      afterEach ->
        @server.restore()
        @ajax_spy.restore()

      it "should DELETE to /dilemmas/:id", ->
        expect(@ajax_spy).toHaveBeenCalledOnce
        expect(@ajax_spy.getCall(0).args[0].url).toBe "/dilemmas/#{@dilemma.id}"
        expect(@ajax_spy.getCall(0).args[0].type).toBe "DELETE"

      it "should remove the dilemma from #dilemmas", ->
        expect(@dilemmas.dilemmas().length).toBe @number_of_dilemmas - 1
        expect(@dilemmas.dilemmas()).not.toContain @dilemma
