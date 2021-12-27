function select_random(group)
  random_position = math.random(#group)
  for i, item in ipairs(group) do
    item.isVisible = false
    if i == random_position then
      item.isVisible = true
    end
  end
end

function dump(t, indent, done)
    done = done or {}
    indent = indent or 0
    done[t] = true
    for key, value in pairs(t) do
        if type(value) == "table" and not done[value] then
            done[value] = true
            print(key, ":")
            dump(value, 0, done)
            done[value] = nil
        else
            print(key, "=", value)
        end
    end
end

function generate()
  eggs = {}
  stains = {}
  augs = {}
  for i, group in ipairs(app.sprites[1].layers) do
    if group.name == "eggs" then
      for _, subgroup in ipairs(group.layers) do
        eggs[#eggs+1] = subgroup.name
      end
    end
    if group.name == "stains" then
      for _, subgroup in ipairs(group.layers) do
        stains[#stains+1] = subgroup.name
      end
    end
    if group.name == "augmentations" then
      for _, subgroup in ipairs(group.layers) do
        augs[#augs+1] = subgroup.name
      end
    end
  end
  combinations = {}
  for _, egg in ipairs(eggs) do
    for _, stain in ipairs(stains) do
      for _, aug in ipairs(augs) do
        combinations[#combinations+1] = {egg, stain, aug}
      end
    end
  end
  -- Generating images
  for number, combination in ipairs(combinations) do
    for _, group in ipairs(app.sprites[1].layers) do
      if group.name == "text" then
        values = prepare_digits_string(number)
        for _, digit_group in ipairs(group.layers) do
          for _, digit_layer in ipairs(digit_group.layers) do
            digit_layer.isVisible = false
            if digit_layer.name == string.sub(values, tonumber(digit_group.name), tonumber(digit_group.name)) then
              digit_layer.isVisible = true
            end
          end
        end
      end
      if group.name == "eggs" then
        for _, subgroup in ipairs(group.layers) do
          subgroup.isVisible = false
          if subgroup.name == combination[1] then
            subgroup.isVisible = true
          end
        end
      end
      if group.name == "stains" then
        for _, subgroup in ipairs(group.layers) do
          subgroup.isVisible = false
          if subgroup.name == combination[2] then
            subgroup.isVisible = true
          end
        end
      end
      if group.name == "augmentations" then
        for _, subgroup in ipairs(group.layers) do
          subgroup.isVisible = false
          if subgroup.name == combination[3] then
            subgroup.isVisible = true
          end
        end
      end
      if group.data == "random" then
        select_random(group.layers)
      end
    end
    app.refresh()
    app.sprites[1]:saveCopyAs("/Users/Dehimb/signalbird/gen/" .. tostring(number) .. "-" .. combination[1] .. "_" .. combination[2] .. "_" .. combination[3] .. ".png")
  end
end

function prepare_digits_string(i)
  if i <= 9 then
    return "000" .. tostring(i)
  elseif i <= 99 then
    return "00" .. tostring(i)
  elseif i <= 999 then
    return "0" .. tostring(i)
  end
  return tostring(i)
end

generate()
