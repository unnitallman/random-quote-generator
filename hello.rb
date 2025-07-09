def is_prime?(n)
  return false if n < 2
  return true if n == 2
  return false if n.even?
  
  # Check odd numbers up to square root of n
  (3..Math.sqrt(n).to_i).step(2) do |i|
    return false if n % i == 0
  end
  true
end

puts "Enter the range for prime numbers"
print "Enter x (start): "
x = gets.chomp.to_i
print "Enter y (end): "
y = gets.chomp.to_i

# Ensure x is less than y
if x > y
  x, y = y, x
end

puts "\nPrime numbers from #{x} to #{y}:"
puts "=" * 40

primes = []
(x..y).each do |num|
  if is_prime?(num)
    primes << num
    print "#{num} "
  end
end

puts "\n\nTotal prime numbers found: #{primes.length}"
if primes.empty?
  puts "No prime numbers found in the given range."
else
  puts "Prime numbers: #{primes.join(', ')}"
end
