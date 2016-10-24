require_relative 'bond'
require 'minitest/autorun'

# tes_bond.rb Test for Bonds class
class TestBonds < Minitest::Test
  def setup
    @bond = Bonds.new(skip_starter: true)

    @challenge_two = {
      gov_bonds: {
        G1: { type: 'government', term: 9.4, yield: 0.037 },
        G2: { type: 'government', term: 12, yield: 0.048 },
        G3: { type: 'government', term: 16.3, yield: 0.055 }
      },
      corp_bond: { type: 'corporate', term: 10.3, yield: 0.053 }
    }
  end

  def test_calculate_spread
    bond = 'C1'
    benchmark = 'G1'
    result = @bond.calculate_spread(bond, benchmark)
    assert_equal 1.6, result
  end

  def test_spread_to_gov_bond_curve_calculator
    result = @bond.spread_to_gov_bond_curve_calculator
    expected = "bond,spread_to_curve\nC1,1.22%\nC2,2.98%\n"
    assert_equal expected, result
  end

  def test_calculate_enclosing_gov_bonds_for
    result = @bond.calculate_enclosing_gov_bonds_for(
      @challenge_two[:gov_bonds],
      @challenge_two[:corp_bond]
    )
    expected = {
      smaller: [:G1, { type: 'government', term: 9.4, yield: 0.037 }],
      greater: [:G2, { type: 'government', term: 12, yield: 0.048 }]
    }
    assert_equal expected, result
  end

  def test_calculate_spread_to_gov_bond_curve_for
    result = @bond.calculate_spread_to_gov_bond_curve_for(
      @challenge_two[:gov_bonds],
      @challenge_two[:corp_bond]
    )
    assert_equal 1.22, result
  end

  def test_interpolate
    c_yield = 0.053
    c_term = 10.3
    g1_yield = 0.037
    g2_yield = 0.048
    g1_term = 9.4
    g2_term = 12
    result = @bond.interpolate(c_term, c_yield, g1_yield,
                               g2_yield, g1_term, g2_term)
                  .round(2)
    assert_equal 1.22, result
  end
end
