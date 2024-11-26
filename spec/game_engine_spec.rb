# frozen_string_literal: true

require_relative("../lib/game_engine")

describe OdinConnectFour::GameEngine do
  describe "#play_game" do
    subject(:game) { described_class.new }
    before do
      allow(game).to receive(:puts)
      allow(game).to receive(:intro_game)
      allow(game).to receive(:play_round)
    end

    it "sends call to explain game" do
      expect(game).to receive(:intro_game)
      game.play_game
    end

    it "outputs winner" do
      expect(game).to receive(:puts)
      game.play_game
    end

    context "when third round ends game" do
      before do
        allow(game).to receive(:play_round).and_return(false, false, true)
      end

      it "stops when game is over" do
        expect(game).to receive(:play_round).exactly(3).times
        game.play_game
      end
    end

    context "when no round ends game" do
      before do
        allow(game).to receive(:play_round).and_return(false)
      end

      it "stops after the 42nd round" do
        expect(game).to receive(:play_round).exactly(42).times
        game.play_game
      end
    end
  end

  describe "#play_round" do
    subject(:game_round) { described_class.new }
    let(:player1) { instance_double("player") }
    before do
      game_round.instance_variable_set(:@player, player1)
      allow(player1).to receive(:grab_move).and_return(3)
      allow(player1).to receive(:char).and_return("O")
      allow(game_round).to receive(:update_game)
      allow(game_round).to receive(:game_over?)
    end

    it "sends call to get move" do
      expect(player1).to receive(:grab_move)
      game_round.play_round
    end

    it "adds move to game state at position 3" do
      move_loc = 3 - 1
      allow(player1).to receive(:grab_move).and_return(3)
      expect { game_round.play_round }.to(change { game_round.instance_variable_get(:@game_state)[move_loc].length }.by(1))
    end

    it "adds move to game state at position 5" do
      move_loc = 5 - 1
      allow(player1).to receive(:grab_move).and_return(5)
      expect { game_round.play_round }.to(change { game_round.instance_variable_get(:@game_state)[move_loc].length }.by(1))
    end

    it "move is player's character" do
      allow(player1).to receive(:char).and_return("Q")
      game_round.play_round
      game = game_round.instance_variable_get(:@game_state)
      expect(game[2][-1]).to eq("Q")
    end

    it "move is player's character" do
      allow(player1).to receive(:char).and_return("#")
      game_round.play_round
      game = game_round.instance_variable_get(:@game_state)
      expect(game[2][-1]).to eq("#")
    end

    it "sends call to check if game over" do
      expect(game_round).to receive(:game_over?)
      game_round.play_round
    end

    it "returns bool for if game is over" do
      result = game_round.play_round
      expect(result).to be(true).or be(false)
    end
  end

  describe "#game_over?" do
    subject(:game_ending) { described_class.new }
    context "when there are 4 horizontally in a row" do
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [["O"], ["O"], ["O"], ["O"], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[X X O O], %w[X X O O], %w[X X O O], %w[O O X O], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
    end
    context "when there are 4 vertically in a row" do
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O O O O], [], [], [], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O X O O O O], [], [], [], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
    end
    context "when there are 4 diagonally in a row" do
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O X O O], %w[O O X X], %w[X X O O], %w[O X O O], [], [], []])
        over = game_ending.game_over?(3)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[X X X O],
                                                         %w[X O O],
                                                         %w[O X X],
                                                         %w[X O],
                                                         %w[O X O],
                                                         %w[X O O O X O],
                                                         []])
        over = game_ending.game_over?(3)
        expect(over).to be_truthy
      end
      it "returns true" do
        game_ending.instance_variable_set(:@game_state, [%w[O O X O O],
                                                         %w[X O O O X],
                                                         %w[O X O O O],
                                                         %w[X O X X X], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_truthy
      end
    end
    context "when there are no 4 in a row" do
      it "returns false" do
        game_ending.instance_variable_set(:@game_state, [%w[O O X O X],
                                                         %w[X O O O X],
                                                         %w[O X O O O],
                                                         %w[X O X X X], [], [], []])
        over = game_ending.game_over?(0)
        expect(over).to be_falsey
      end
      it "returns false" do
        game_ending.instance_variable_set(:@game_state, [%w[O O X O X O],
                                                         %w[X O O O X X],
                                                         %w[O X O O O X],
                                                         %w[X O X X X O],
                                                         %w[X X O O X O],
                                                         %w[O X O X O X],
                                                         %w[O X O X X O]])
        over = game_ending.game_over?(2)
        expect(over).to be_falsey
      end
    end
  end
end
