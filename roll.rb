# ruby roll.rb [roll]
# examples: d20, 2d8+5, 2d20k1, 2d20kl+6, 4d6kh3

class Roll
  attr_accessor :rolls, :result, :modifier

  def initialize(count: nil, die:, modifier: nil, hilo: nil, keep: nil)
    @count = Integer(count || 1)
    @die = Integer(die)
    @modifier = Integer(modifier || 0)
    @hilo, @keep = String(hilo[1] || "h"), Integer(keep || 1) if hilo
    do_roll
  end

  private

  def do_roll
    @rolls = @count.times.map { roll_die }

    @result = case @hilo
    when "h" then @rolls.sort.reverse.take(@keep)
    when "l" then @rolls.sort.take(@keep)
    else @rolls
    end.reduce(0, &:+) + modifier

    @rolls << modifier if modifier != 0
  end

  def roll_die
    rand(@die) + 1
  end
end

SYNTAX = /^(?<count>\d+)?d(?<die>\d+)((?<hilo>k[hl]?)(?<keep>\d+)?)?(\+(?<modifier>\d+))?$/i

match_data = ARGV[0].chomp.match(SYNTAX)
roll = Roll.new(**match_data.named_captures.transform_keys(&:to_sym).compact)

puts <<-OUTPUT
#{roll.rolls.join(" + ")} = #{roll.result}
OUTPUT
