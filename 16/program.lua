#!/usr/bin/env lua

function string:split(sep)
   local fields = {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

rules = {}
tickets = {}
reading = "rules"

for line in io.lines("input.txt") do
   if line == "" then
      if reading == "rules" then
         reading = "tickets"
      end
   elseif reading == "rules" then
      local _, _, field, from1, to1, from2, to2 = string.find(line, "([%a ]+): (%d+)-(%d+) or (%d+)-(%d+)")
      rules[field] = { from1=tonumber(from1), to1=tonumber(to1), from2=tonumber(from2), to2=tonumber(to2) }
   elseif reading == "tickets" then
      if line:find("ticket") then ;
      else
         local values = string.split(line, ",")
         for k, v in pairs(values) do
            values[k] = tonumber(v)
         end
         table.insert(tickets, values)
      end
   end
end

function is_valid_value(value, rule)
   return (value >= rule.from1 and value <= rule.to1) or (value >= rule.from2 and value <= rule.to2)
end

sum = 0
valid_tickets = {}

for _, ticket in pairs(tickets) do
   local valid_ticket = true
   for _, value in pairs(ticket) do
      local valid_val = false
      for _, rule in pairs(rules) do
         if is_valid_value(value, rule) then
            valid_val = true
            break
         end
      end
      if not valid_val then
         sum = sum + value
         valid_ticket = false
      end
   end
   if valid_ticket then
      table.insert(valid_tickets, ticket)
   end
end

print(sum)

-- part 2

my_ticket = tickets[1]

possibilities = {}

for field, rule in pairs(rules) do
   local poss = {}
   for i = 1, #my_ticket do
      poss[i] = true
   end
   for _, ticket in pairs(valid_tickets) do
      for i, value in pairs(ticket) do
         if not is_valid_value(value, rule) then
            poss[i] = false
         end
      end
   end
   possibilities[field] = poss
end

function has_value(tab, value)
   for _, v in pairs(tab) do
      if value == v then
         return true
      end
   end
   return false
end

matches = {}

for _ = 1, #my_ticket do
   for field, data in pairs(possibilities) do
      local c = 0
      local p
      for i, v in pairs(data) do
         if v and not has_value(matches, i) then
            c = c + 1
            p = i
         end
      end
      if c == 1 then
         matches[field] = p
         break
      end
   end
end

prod = 1

for k, v in pairs(matches) do
   if k:find("departure") == 1 then
      prod = prod * my_ticket[v]
   end
end

print(prod)
