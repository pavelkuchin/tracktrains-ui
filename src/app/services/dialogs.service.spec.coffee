describe 'DialogsService', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach module ($provide) =>
    () =>
      @mockModal = jasmine.createSpyObj('$modal', ['open'])

      $provide.value('$modal', @mockModal)


  beforeEach inject (DialogsService, $q, @$rootScope, $httpBackend) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    $httpBackend.when('GET', 'app/pages/landing/pages.landing.template.html')
      .respond({})

    @DialogsService = DialogsService
    @mockModal.open.and.returnValue({result: $q.when()})

  describe 'service.confirmation', () =>
    it 'open confirmation dialog', () =>
      @DialogsService.confirmation('test header', 'test')

      @$rootScope.$digest()

      expect(@mockModal.open).toHaveBeenCalled()

  describe 'service.confirmationWithPassword', () =>
    it 'open confirmationWithPassword dialog', () =>
      @DialogsService.confirmationWithPassword('test header', 'test')

      @$rootScope.$digest()

      expect(@mockModal.open).toHaveBeenCalled()
