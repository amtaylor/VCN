object @company
attributes :id, :name
child(:investors){extends 'investors/show'}