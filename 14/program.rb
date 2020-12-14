#!/usr/bin/env ruby

mem = {}

mask = nil
File.open('input.txt').each do |line|
  if (m = line.match(/mask = ([01X]{36})/))
    mask = m[1].chars
  elsif (m = line.match(/mem\[(\d+)\] = (\d+)/))
    addr = m[1].to_i
    val = m[2].to_i
    mask.each_with_index do |c, i|
      case c
      when '0'
        val &= ~(1 << (mask.size - 1 - i))
      when '1'
        val |= (1 << (mask.size - 1 - i))
      end
    end
    mem[addr] = val
  end
end

puts mem.values.reduce(:+)

# part 2

mem = {}

mask = nil
File.open('input.txt').each do |line|
  if (m = line.match(/mask = ([01X]{36})/))
    mask = m[1].chars
  elsif (m = line.match(/mem\[(\d+)\] = (\d+)/))
    addr = m[1].to_i
    val = m[2].to_i
    floats = []
    mask.each_with_index do |c, i|
      case c
      when '1'
        addr |= (1 << (mask.size - 1 - i))
      when 'X'
        floats.append(mask.size - 1 - i)
      end
    end
    (2**floats.size).times do |k|
      a = addr
      floats.reverse.each_with_index do |n, i|
        bit = k[i]
        if bit == 1
          a |= (1 << n)
        else
          a &= ~(1 << n)
        end
      end
      mem[a] = val
    end
  end
end

puts mem.values.reduce(:+)
