require 'rubygems'
require 'csv'
require 'pp'

# Calculate the bond spread for challenge one
# and the spread to curve for challenge two.
class Bonds
  def initialize(skip_starter: false)
    @challenge_one_bonds = {
      C1: { type: 'corporate', term: 10.3, yield: 0.0530 },
      G1: { type: 'government', term: 9.4, yield: 0.0370 },
      G2: { type: 'government', term: 12, yield: 0.0480 }
    }
    @challenge_two_bonds = {
      C1: { type: 'corporate', term: 10.3, yield: 0.0530 },
      C2: { type: 'corporate', term: 15.2, yield: 0.0830 },
      G1: { type: 'government', term: 9.4, yield: 0.0370 },
      G2: { type: 'government', term: 12, yield: 0.0480 },
      G3: { type: 'government', term: 16.3, yield: 0.0550 }
    }
    return false if skip_starter
    home_screen
  end

  # DISPLAY
  def home_screen
    puts 'Pick a Challenge'
    puts '1 : Calculate the yield spread (return) between a corporate bond and its government bond benchmark'
    puts '2 : Calculate the spread to the government bond curve'
    puts '3 : Exit'
    user_input = gets.to_i
    select_challenge(user_input)
  end

  def select_challenge(answer)
    case answer
    when 1
      pp @challenge_one_bonds
      yield_spread_calculator('C1')
    when 2
      pp @challenge_two_bonds
      puts spread_to_gov_bond_curve_calculator
    when 3
      exit
    else
      puts 'Select 1 or 2'
      home_screen
    end
  end

  def select_benchmark
    puts 'Select a Government bond to benchmark with the bond C1'
    puts '1: G1'
    puts '2: G2'
    puts '3: Go Back'
    benchmark_input = gets.chomp.to_i

    case benchmark_input
    when 1
      'G1'
    when 2
      'G2'
    when 3
      return home_screen
    else
      benchmark = select_benchmark
      return calculate_yield_spread(bond, benchmark)
    end
  end

  def yield_spread_calculator(bond)
    benchmark = select_benchmark
    result = calculate_spread(bond, benchmark)

    heading = %w(bond benchmark spread_to_benchmark)
    formatted_result = [
      heading,
      [bond.to_s, benchmark.to_s, "#{format('%.2f', result)}%"]
    ]

    puts formatted_result.map(&:to_csv).join
  end

  def spread_to_gov_bond_curve_calculator
    gov_bonds = @challenge_two_bonds.select { |key, _value| @challenge_two_bonds[key][:type] == 'government' }

    c1_result = calculate_spread_to_gov_bond_curve_for(gov_bonds, @challenge_two_bonds[:C1])
    c2_result = calculate_spread_to_gov_bond_curve_for(gov_bonds, @challenge_two_bonds[:C2])

    heading = %w(bond spread_to_curve)
    formatted_result = [
      heading,
      ['C1', "#{format('%.2f', c1_result)}%"],
      ['C2', "#{format('%.2f', c2_result)}%"]
    ]

    formatted_result.map(&:to_csv).join
  end
  # CALCULATORS

  def calculate_enclosing_gov_bonds_for(gov_bonds, corp_bond)
    smaller_gov_bonds = []
    greater_gov_bonds = []

    gov_bonds.each do |gov_bond|
      gov_bond_term = gov_bond[1][:term]
      smaller_gov_bonds << gov_bond if gov_bond_term < corp_bond[:term]
      greater_gov_bonds << gov_bond if gov_bond_term > corp_bond[:term]
    end

    smaller_gov_bond = smaller_gov_bonds.max
    greater_gov_bond = greater_gov_bonds.min

    {
      smaller: smaller_gov_bond,
      greater: greater_gov_bond
    }
  end

  def calculate_spread_to_gov_bond_curve_for(gov_bonds, corp_bond)
    enclosing_gov_bonds = calculate_enclosing_gov_bonds_for(gov_bonds, corp_bond)

    smaller_gov_bond_term = enclosing_gov_bonds[:smaller][1][:term]
    greater_gov_bond_term = enclosing_gov_bonds[:greater][1][:term]

    smaller_gov_bond_yield = enclosing_gov_bonds[:smaller][1][:yield]
    greater_gov_bond_yield = enclosing_gov_bonds[:greater][1][:yield]

    c_yield = corp_bond[:yield]
    c_term = corp_bond[:term]

    g1_yield = smaller_gov_bond_yield
    g2_yield = greater_gov_bond_yield

    g1_term = smaller_gov_bond_term
    g2_term = greater_gov_bond_term

    # interpolate
    interpolate(c_term, c_yield, g1_yield, g2_yield, g1_term, g2_term).round(2)
  end

  def interpolate(c_term, c_yield, g1_yield, g2_yield, g1_term, g2_term)
    interpolated_yield = (g1_yield + ((c_term - g1_term) * ((g2_yield - g1_yield)/ (g2_term - g1_term))))
    spread_to_curve = (c_yield - interpolated_yield)
    spread_to_curve * 100
  end

  def calculate_spread(bond, benchmark)
    (@challenge_one_bonds[bond.to_sym][:yield] - @challenge_one_bonds[benchmark.to_sym][:yield]) * 100
  end
end
