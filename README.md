# Coding Challenge

### Challenge #1

  Calculate the yield spread (return) between a corporate bond and its government bond benchmark.

  ### Sample input

| bond   | type       | term        | yield |
|--------|------------|-------------|-------|
| C1     | corporate  | 10.3 years  | 5.30% |
| G1     | government | 9.4 years   | 3.70% |
| G2     | government | 12 years    | 4.80% |

### Challenge #2

Calculate the spread to the government bond curve.

### Sample input

| bond   | type       | term        | yield |
|--------|------------|-------------|-------|
| C1     | corporate  | 10.3 years  | 5.30% |
| C2     | corporate  | 15.2 years  | 8.30% |
| G1     | government | 9.4 years   | 3.70% |
| G2     | government | 12 years    | 4.80% |
| G3     | government | 16.3 years  | 5.50% |

## Run Challenges

    ruby run_challenges.rb

## Run test

    ruby test_bond.rb

## Technical choices

'csv' for displaying the data in table
'minitest' is a light testing library that can be read in 1 hour. I wanted to opt for a light alternative to RSPEC.
'pp' just make printing data prettier

## Trade-offs

I could have used the gem 'interpolation' but it wouldn't have shown that I clearly understand how to calculate the spread. Also the gem requires to install nmatrix adn gcc which would have actually made things complicated for the reviewer. 
