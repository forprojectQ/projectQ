local loader = new('loader')

function loader.prototype.____constructor(self)
    local ipairs = ipairs
    self.primarys = {'mysql','fonts'}
    for index, value in ipairs(self.primarys) do
        Resource.getFromName(value):start()
    end
    for index, value in ipairs(getResources()) do
        value:start()
    end
end

load(loader)