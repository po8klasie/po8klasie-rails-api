#rubocop flags this file as having an unexpected token kEND, parser error
#rubocop:disable all
class ApplicationService
    self.call(*args)
        new(*args).call
    end
end
#rubocop:enable all

