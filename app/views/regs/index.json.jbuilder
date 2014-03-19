json.array!(@regs) do |reg|
  json.extract! reg, :id, :regid, :x, :y
  json.url reg_url(reg, format: :json)
end
