local StatefulObjectTypes = {
  'State',
  'Delay',
  'Stopwatch',
}

return function(object: any)
  return typeof(object) == 'table' and table.find(StatefulObjectTypes, object.type)
end